//
//  In.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 21/02/2023.
//

import Foundation


struct In: Operator {
    static let id = OperatorID.in_
    private let value: AnyCodable

    init(value: AnyCodable, params: [String : Any]?) throws {
        self.value = value
    }

    func match(_ objValue: Any) -> Bool {
        switch self.value.valueType {
        case .string:
            guard let rhs = objValue as? String,
                  let lhs = self.value.value as? String else {
                return false
            }

            return lhs.contains(rhs)

        case .array:
            guard let lhs = self.value.value as? NSArray else {
                return false
            }

            return lhs.contains(objValue)

        default:
            return false
        }
    }
}

