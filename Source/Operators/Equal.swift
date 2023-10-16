//
//  Equal.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 21/02/2023.
//

import Foundation



struct Equal: Operator {
    static let id = OperatorID.equal
    private let value: AnyCodable

    init(value: AnyCodable, params: [String : Any]?) throws {
        self.value = value
    }

    func match(_ objValue: Any) -> Bool {

        switch self.value.valueType {
        case .bool, .string, .number:
            guard let rhs = objValue as? AnyHashable,
                  let lhs = self.value.value as? AnyHashable else {
                return false
            }

            return lhs == rhs

        case .dictionary:
            guard let rhs = objValue as? NSDictionary,
                  let lhs = self.value.value as? NSDictionary else {
                return false
            }
            return lhs == rhs

        case .array:
            guard let rhs = objValue as? NSArray,
                  let lhs = self.value.value as? NSArray else {
                return false
            }

            // NOTE: This matches is arrays have the same elements in
            // the same order
            return lhs == rhs

        case .null:
            return objValue is NSNull

        default:
            return false
        }
    }
}
