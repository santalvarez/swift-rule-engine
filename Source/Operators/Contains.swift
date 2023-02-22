//
//  Contains.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 21/02/2023.
//

import Foundation


struct Contains: Operator {
    let id = "contains"
    
    func match(_ condition: SimpleCondition, _ objValue: Any) -> Bool {
        // NOTE: I think i can't use valueType here i need to make
        // a decision based on objValue instead
        switch condition.value.valueType {
        case .string:
            guard let lhs = condition.value.value as? String,
                  let rhs = objValue as? String else {
                return false
            }

            return rhs.contains(lhs)

        case .array:
            return true

        case .bool, .dictionary, .number, .null, .unknown:
            return false
        }
    }
}

