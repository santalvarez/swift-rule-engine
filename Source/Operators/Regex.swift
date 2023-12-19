//
//  Regex.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 02/03/2023.
//

import Foundation


struct Regex: Operator {
    static let id = OperatorID(rawValue: "regex")
    let regex: NSRegularExpression

    init(value: AnyCodable, params: [String : Any]?) throws {
        guard let pattern = value.value as? String else {
            throw OperatorError.invalidValueType
        }

        guard let reg = try? NSRegularExpression(pattern: pattern) else {
            throw OperatorError.invalidValue
        }
        self.regex = reg
    }

    func match(_ objValue: Any) -> Bool {
        guard let rhs = objValue as? String else {
            return false
        }

        let range = NSRange(location: 0, length: rhs.utf16.count)
        return regex.firstMatch(in: rhs, range: range) != nil
    }
}
