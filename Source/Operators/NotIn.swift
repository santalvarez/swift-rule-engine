//
//  NotIn.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 21/02/2023.
//

import Foundation


struct NotIn: Operator {
    let id = OperatorID.not_in

    func match(_ condition: SimpleCondition, _ objValue: Any) -> Bool {
        switch condition.value.valueType {
        case .string:
            guard let rhs = objValue as? String,
                  let lhs = condition.value.value as? String else {
                return false
            }

            return !lhs.contains(rhs)

        case .array:
            guard let lhs = condition.value.value as? NSArray else {
                return false
            }

            return !lhs.contains(objValue)

        default:
            return false
        }
    }
}

