//
//  NotContainsRegex.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 04/04/2023.
//

import Foundation

struct NotContainsRegex: Operator {
    let id = OperatorID.not_contains_regex

    func match(_ condition: SimpleCondition, _ objValue: Any) -> Bool {
        if condition.value.valueType != .regex {
            return false
        }

        guard let lhs = condition.value.value as? NSRegularExpression,
              let rhs = objValue as? [String] else {
            return false
        }

        return !rhs.contains { string in
            let range = NSRange(location: 0, length: string.utf16.count)
            return (lhs.firstMatch(in: string, range: range) != nil)
        }
    }
}
