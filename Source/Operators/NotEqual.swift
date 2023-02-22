//
//  NotEqual.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 21/02/2023.
//

import Foundation


struct NotEqual: Operator {
    let id = "not_equal"
    
    func match(_ condition: SimpleCondition, _ objValue: Any) -> Bool {
        switch condition.value.valueType {
        case .bool, .string, .number, .array:
            guard let rhs = objValue as? AnyHashable,
                  let lhs = condition.value.value as? AnyHashable else {
                return false
            }
        
            return lhs == rhs
            
        case .dictionary:
            guard let rhs = objValue as? NSDictionary,
                  let lhs = condition.value.value as? NSDictionary else {
                return false
            }
            return lhs == rhs

        case .null:
            return objValue is NSNull
        
        case .unknown:
            return false
        }
    }
}