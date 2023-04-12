//
//  NotRegex.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 11/04/2023.
//

import Foundation


struct NotRegex: Operator {
    let id = OperatorID.not_regex

    func match(_ condition: SimpleCondition, _ objValue: Any) -> Bool {
        if condition.value.valueType != .regex {
            return false
        }

        guard let regex = condition.value.value as? NSRegularExpression,
              let rhs = objValue as? String else {
            return false
        }

        let range = NSRange(location: 0, length: rhs.utf16.count)
        return regex.firstMatch(in: rhs, range: range) == nil
    }
}
