//
//  LessThan.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 21/02/2023.
//

import Foundation


struct LessThan: Operator {
    let id = "less_than"
    
    func match(_ condition: SimpleCondition, _ objValue: Any) -> Bool {
        switch condition.value.valueType {
        case .number:
            guard let lhs = condition.value.value as? Double,
                  let rhs = objValue as? Double else {
                return false
            }
            
            return lhs > rhs
            
        case .string:
            guard let lhs = condition.value.value as? Double,
                  let rhs = objValue as? Double else {
                return false
            }
            
            return lhs > rhs

        case .array:
            return true

        case .bool, .dictionary, .null, .unknown:
            return false
        }
    }
}

