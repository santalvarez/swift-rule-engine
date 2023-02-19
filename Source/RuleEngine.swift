//
//  RuleEngine.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 21/12/2022.
//

import Foundation

final class RuleEngine {
    var operators: [String: Operator] = [:]
    
    init(rules: [[String: Any]], operators: [Operator] = []) {
        for op in operators {
            self.operators[op.id] = op
        }
    }
    
    private func mergeOperators(operators: [Operator]) {
        
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
    
    private func getValueFromJSONPath(path: String, obj: [String: AnyCodable]) -> AnyCodable {
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
    
    private func runCondition(condition: SimpleCondition, obj: Any) {
        
    }
    
    private func runMultiCondition(condition: MultiCondition, obj: Any) {
        
    }
    
    func evaluate(obj: Any) {
        
    }
}
