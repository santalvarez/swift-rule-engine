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

        if let lhs = condition.value.value as? Set<String>,
           let rhs = objValue as? String {
            return lhs.contains(rhs)
        }
        if let lhs = condition.value.value as? Set<Int>,
           let rhs = objValue as? Int {
            return lhs.contains(rhs)
        }
        if let lhs = condition.value.value as? Set<Double>,
           let rhs = objValue as? Double {
            return lhs.contains(rhs)
        }
        return false
    }
}
