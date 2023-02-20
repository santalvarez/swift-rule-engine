//
//  RuleEngine.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 21/12/2022.
//

import Foundation

final class RuleEngine {
    private var operators: [String: Operator]
    private var rules: [Rule]
    
    
    init(rules: [[String: Any]], customOperators: [Operator] = []) {
        // Set up operators
        let defaultOperators: [Operator] = [Equal()]
        let operators: [Operator] = defaultOperators + customOperators
        
        for op in operators {
            self.operators[op.id] = op
        }

        // Load rules
        self.rules = self.loadRules(rules: rules)
    }


    private func loadRules(rules: [[String: Any]]) -> [Rule] {
        var decodedRules:  [Rule] = []
        for rule in rules {
            guard let ruleData = try? JSONSerialization.data(withJSONObject: rule, options: []) else {
                continue
            }

            guard let decodedRule = try? JSONDecoder().decode(Rule.self, from: ruleData) else {
                // TODO: log failure
                continue
            }
            
            decodedRules.append(decodedRule)
        }
        return decodedRules
    }
    
    private func getValueFromJSONPath(path: String, obj: Any) -> AnyCodable {
        // path is like $.person.name
        // should return the value of name
        var path = path.replacingOccurrences(of: "$.", with: "")
        let pathComponents = path.components(separatedBy: ".")
        
        var currentObj: [String: AnyCodable] = obj
        for component in pathComponents {
            if currentObj[component].valueType == .dictionary {
                // keep looping
            } else {
                return currentObj
            }
            
        }
        
    }
    
    
    private func runCondition(_ condition: SimpleCondition, _ obj: Any) -> SimpleCondition {
        // TODO: consider using inout args

        var condition = condition
        let pathObj: Any
        if condition.path != nil {
            pathObj = self.getValueFromJSONPath(path: condition.path!, obj: obj)
        } else {
            pathObj = obj
        }
        
        condition.match = self.operators[condition.op]?.match(condition, pathObj) ?? false
        
        return condition
    }

    private func runMultiCondition(_ multiCondition: MultiCondition, _ obj: Any) -> MultiCondition {
        var multiCondition = multiCondition
        
        var conditions = multiCondition.getConditions()

        var allMatch = true
        
        for (idx, condition) in conditions.enumerated() {
            let result: Condition
            
            switch condition {
            case .multi(let cond):
                result = Condition(self.runMultiCondition(cond, obj))

            case .simple(let cond):
                result = Condition(self.runCondition(cond, obj))
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
            let result = self.runMultiCondition(rule.conditions, obj)
            if result.match {
                rule.conditions = result
                return rule
            }
        }
        return nil
    }
}
