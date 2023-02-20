//
//  RuleEngine.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 21/12/2022.
//

import Foundation


enum RuleEngineError: Error {
    case operatorNotFound
    case duplicateOperator
    case invalidRule
}

final class RuleEngine {
    private var operators: [String: Operator]
    private var rules: [Rule]
    private let pathParser: PathParser
    

    init(rules: [[String: Any]], customOperators: [Operator] = []) throws {
        // TODO: add flag to ignore error if rule cannot de decoded
        // Set up operators
        let defaultOperators: [Operator] = [Equal()]
        let operators: [Operator] = defaultOperators + customOperators
        
        self.operators = [:]
        for op in operators {
            if self.operators[op.id] != nil {
                throw RuleEngineError.duplicateOperator
            }
            self.operators[op.id] = op
        }

        // Load rules
        self.rules = Self.decodeRules(rules: rules)
        
        self.pathParser = PathParser()
    }

    private static func decodeRules(rules: [[String: Any]]) -> [Rule] {
        var decodedRules:  [Rule] = []
        for rule in rules {
            guard let ruleData = try? JSONSerialization.data(withJSONObject: rule, options: []) else {
                // throw RuleEngineError.invalidRule
                continue
            }

            guard let decodedRule = try? JSONDecoder().decode(Rule.self, from: ruleData) else {
                // throw RuleEngineError.invalidRule
                continue
            }
            
            decodedRules.append(decodedRule)
        }
        return decodedRules
    }


    private func runCondition(_ condition: SimpleCondition, _ obj: Any) throws -> SimpleCondition {
        var condition = condition
        let pathObj: Any
        if condition.path != nil {
            pathObj = try self.pathParser.getValue(condition.path!, obj)
        } else {
            pathObj = obj
        }
        
        guard let op = self.operators[condition.op] else {
            throw RuleEngineError.operatorNotFound
        }
        
        condition.match = op.match(condition, pathObj)
        
        return condition
    }

    private func runMultiCondition(_ multiCondition: MultiCondition, _ obj: Any) throws -> MultiCondition {
        var multiCondition = multiCondition
        
        var conditions = multiCondition.getConditions()

        var allMatch = true
        
        for (idx, condition) in conditions.enumerated() {
            let result: Condition
            
            switch condition {
            case .multi(let cond):
                result = Condition(try self.runMultiCondition(cond, obj))

            case .simple(let cond):
                result = Condition(try self.runCondition(cond, obj))
            }
            
            conditions[idx] = result
            
            if multiCondition.any != nil {
                if result.getMatch() {
                    multiCondition.match = true
                    break
                }
            } else {
                if !result.getMatch() {
                    allMatch = false
                    break
                }
            }
        }
        
        if multiCondition.all != nil {
            multiCondition.match = allMatch
        }

        multiCondition.replaceConditions(conditions)
        
        return multiCondition
    }

    func evaluate(obj: [String: Any]) -> Rule? {
        for rule in self.rules {
            var rule = rule
            guard let result = try? self.runMultiCondition(rule.conditions, obj) else {
                continue
            }

            if result.match {
                rule.conditions = result
                return rule
            }
        }
        return nil
    }
}
