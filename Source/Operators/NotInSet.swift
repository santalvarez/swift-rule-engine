//
//  NotInSet.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 12/03/2023.
//

import Foundation

struct NotInSet: Operator {
    let id = OperatorID.not_in_set

    func match(_ condition: SimpleCondition, _ objValue: Any) -> Bool {
        if condition.value.valueType != .set {
            return false
        }

        guard let lhs = condition.value.value as? Set<String>,
              let rhs = objValue as? String else {
            return false
        }

        return !lhs.contains(rhs)
    }
}
