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
            guard let lhs = condition.value.value as? NSNumber,
                  let rhs = objValue as? NSNumber else {
                return false
            }
            
            return lhs.doubleValue > rhs.doubleValue
            
        case .string:
            guard let lhs = condition.value.value as? String,
                  let rhs = objValue as? String else {
                return false
            }
            
            return lhs > rhs

        case .bool, .array, .dictionary, .null, .unknown:
            return false
        }
    }
}

