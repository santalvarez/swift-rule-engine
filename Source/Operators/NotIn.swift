//
//  NotIn.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 21/02/2023.
//

import Foundation


struct NotIn: Operator {
    static let id = OperatorID(rawValue: "not_in")
    private let value: Any

    init(value: AnyCodable, params: [String : Any]?) throws {
        switch value {
        case .string(let string):
            self.value = string
        case .array(let array):
            if let array = array as? [AnyHashable] {
                self.value = Set(array)
            } else {
                self.value = array as NSArray
            }
        default:
            throw OperatorError.invalidValueType
        }
    }

    func match(_ objValue: Any) -> Bool {
        if let lhs = self.value as? String, let rhs = objValue as? String {
            return !lhs.contains(rhs)
        } else if let lhs = self.value as? Set<AnyHashable>, let rhs = objValue as? AnyHashable {
            return !lhs.contains(rhs)
        } else if let lhs = self.value as? NSArray {
            return !lhs.contains(objValue)
        }
        return true
    }
}

