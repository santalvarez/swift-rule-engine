//
//  Equal.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 21/02/2023.
//

import Foundation



struct Equal: Operator {
    let id = "equal"

    func match(_ condition: SimpleCondition, _ objValue: Any) -> Bool {

        switch condition.value.valueType {
        case .bool, .string, .number, .array:
            // TODO: find a better way to compare arrays

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
