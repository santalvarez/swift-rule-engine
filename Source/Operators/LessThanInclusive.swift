//
//  LessThanInclusive.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 21/02/2023.
//

import Foundation


struct LessThanInclusive: Operator {
    static let id = OperatorID(rawValue: "less_than_inclusive")
    private let value: AnyCodable

    init(value: AnyCodable, params: [String : Any]?) throws {
        self.value = value
    }

    func match(_ objValue: Any) -> Bool {
        switch self.value {
        case .number(let lhs):
            guard let rhs = objValue as? NSNumber else {
                return false
            }

            return lhs.doubleValue >= rhs.doubleValue

        case .string(let lhs):
            guard let rhs = objValue as? String else {
                return false
            }

            return lhs >= rhs

        default:
            return false
        }
    }
}
