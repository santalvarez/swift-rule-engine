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
    case invalidRule(String)
}

final class RuleEngine {
    private var operators: [String: Operator]
    private var rules: [Rule] = []
    private let pathParser: PathParser = PathParser()
    
    
    // Init for rules that come in string format
    init(rules: [String], customOperators: [Operator]) throws {
        self.operators = try Self.generateOperatorsDict(customOperators)
        self.rules = rules.compactMap{ dictRule in
            try? Self.decodeRule(rule: dictRule)
        }
    }

    init(rules: [[String: Any]], customOperators: [Operator] = []) throws {
        self.operators = try Self.generateOperatorsDict(customOperators)
        self.rules = rules.compactMap{ dictRule in
            try? Self.decodeRule(rule: dictRule)
        }
    }
    
    private static func generateOperatorsDict(_ customOperators: [Operator]) throws -> [String:Operator]{
        let defaultOperators: [Operator] = [Equal(), NotEqual(), LessThan(), LessThanInclusive(),
                                            GreaterThan(), GreaterThanInclusive(), In(), NotIn(),
                                            Contains(), NotContains(), Regex()]
        let operators = defaultOperators + customOperators

        return try operators.reduce(into: [:]) { result, op in
            guard result[op.id] == nil else {
                throw RuleEngineError.duplicateOperator
            }
            result[op.id] = op
        }
    }
    
    private static func decodeRule(rule: [String: Any]) throws -> Rule {
        guard let ruleData = try? JSONSerialization.data(withJSONObject: rule, options: []) else {
            throw RuleEngineError.invalidRule("Error converting dict to data")
        }

        guard let rule = try? JSONDecoder().decode(Rule.self, from: ruleData) else {
            throw RuleEngineError.invalidRule("Error decoding rule")
        }
        return rule
    }
    
    private static func decodeRule(rule: String) throws -> Rule {
        guard let ruleData = rule.data(using: .utf8) else {
            throw RuleEngineError.invalidRule("Rule not in utf8 format")
        }
        
        guard let rule = try? JSONDecoder().decode(Rule.self, from: ruleData) else {
            throw RuleEngineError.invalidRule("Error decoding rule")
        }
        return rule
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

    func evaluate(_ obj: [String: Any]) -> Rule? {
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
