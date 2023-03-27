//
//  InSet.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 11/03/2023.
//

import Foundation


struct InSet: Operator {
    let id = OperatorID.in_set

    func match(_ condition: SimpleCondition, _ objValue: Any) -> Bool {
        if condition.value.valueType != .set {
            return false
        }

        guard let lhs = condition.value.value as? Set<AnyHashable>,
              let rhs = objValue as? AnyHashable else {
            return false
        }

        return lhs.contains(rhs)
    }
}
