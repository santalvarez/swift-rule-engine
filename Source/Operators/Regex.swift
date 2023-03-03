//
//  Regex.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 02/03/2023.
//

import Foundation


struct RegexOperator: Operator {
    let id = "regex"
    private var cache = NSCache<NSString, NSRegularExpression>()

    private func regularExpression(for pattern: String) throws -> NSRegularExpression {
        if let regex = cache.object(forKey: pattern as NSString) {
            return regex
        }
        let regex = try NSRegularExpression(pattern: pattern)
        cache.setObject(regex, forKey: pattern as NSString)
        return regex
    }

    func match(_ condition: SimpleCondition, _ objValue: Any) -> Bool {
        if condition.value.valueType != .string {
            return false
        }
        
        guard let regexString = condition.value.value as? String,
              let rhsString = objValue as? String else {
            return false
        }
        
        do {
            let regex = try self.regularExpression(for: regexString)
            let range = NSRange(location: 0, length: rhsString.utf16.count)
            let matches = regex.matches(in: rhsString, range: range)
            return matches.count > 0
        } catch {
            return false
        }
    }
}
