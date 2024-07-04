//
//  EndsWith.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 04/12/2023.
//

import Foundation


struct EndsWith: Operator {
    static let id = OperatorID(rawValue: "endswith")
    private let value: String

    init(value: AnyCodable, params: [String : Any]?) throws {
        switch value {
        case .string(let str):
            self.value = str
        default:
            throw OperatorError.invalidValueType

        }
    }

    func match(_ objValue: Any) -> Bool {
        guard let rhs = objValue as? String else {
            return false
        }

        return rhs.hasSuffix(value)
    }
}

struct NotEndsWith: Operator {
    static let id = OperatorID(rawValue: "not_endswith")
    private let value: String

    init(value: AnyCodable, params: [String : Any]?) throws {
        switch value {
        case .string(let str):
            self.value = str
        default:
            throw OperatorError.invalidValueType

        }
    }

    func match(_ objValue: Any) -> Bool {
        guard let rhs = objValue as? String else {
            return false
        }

        return !rhs.hasSuffix(value)
    }
}
