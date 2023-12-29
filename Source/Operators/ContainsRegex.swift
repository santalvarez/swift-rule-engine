//
//  ContainsRegex.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 04/04/2023.
//

import Foundation


struct ContainsRegex: Operator {
    static let id = OperatorID(rawValue: "contains_regex")
    private let regex: NSRegularExpression

    init(value: AnyCodable, params: [String : Any]?) throws {
        if case .string(let pattern) = value {
            guard let reg = try? NSRegularExpression(pattern: pattern) else {
                throw OperatorError.invalidValue
            }
            self.regex = reg
            return
        }
        throw OperatorError.invalidValueType
    }

    func match(_ objValue: Any) -> Bool {
        guard let rhs = objValue as? [String] else {
            return false
        }

        return rhs.contains { string in
            let range = NSRange(location: 0, length: string.utf16.count)
            return (regex.firstMatch(in: string, range: range) != nil)
        }
    }
}
