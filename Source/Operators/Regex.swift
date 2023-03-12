//
//  Regex.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 02/03/2023.
//

import Foundation


struct Regex: Operator {
    let id = OperatorID.regex

    func match(_ condition: SimpleCondition, _ objValue: Any) -> Bool {
        if condition.value.valueType != .regex {
            return false
        }

        guard let regex = condition.value.value as? NSRegularExpression,
              let rhs = objValue as? String else {
            return false
        }

        let range = NSRange(location: 0, length: rhs.utf16.count)
        return regex.firstMatch(in: rhs, range: range) != nil
    }
}
