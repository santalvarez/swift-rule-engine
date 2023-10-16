//
//  InSet.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 11/03/2023.
//

import Foundation


struct InSet: Operator {
    static let id = OperatorID.in_set
    private let value: AnyCodable

    init(value: AnyCodable, params: [String : Any]?) throws {
        self.value = value
    }

    func match(_ objValue: Any) -> Bool {
        if self.value.valueType != .array {
            return false
        }

        if let lhs = self.value.value as? Set<String>,
           let rhs = objValue as? String {
            return lhs.contains(rhs)
        }
        if let lhs = self.value.value as? Set<Int>,
           let rhs = objValue as? Int {
            return lhs.contains(rhs)
        }
        if let lhs = self.value.value as? Set<Double>,
           let rhs = objValue as? Double {
            return lhs.contains(rhs)
        }
        return false
    }
}
