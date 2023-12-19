//
//  In.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 21/02/2023.
//

import Foundation


struct In: Operator {
    static let id = OperatorID(rawValue: "in")
    private let value: AnyCodable

    init(value: AnyCodable, params: [String : Any]?) throws {
        guard [VType.string, VType.array].contains(value.valueType) else {
            throw OperatorError.invalidValueType
        }
        // if array try to convert it to a Set
        if value.valueType == .array,
           let array = value.value as? [AnyHashable] {
            self.value = AnyCodable(value: Set(array), valueType: .array)
            return
        }
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
            if let lhs = self.value.value as? Set<AnyHashable>,
               let rhs = objValue as? AnyHashable {
                return lhs.contains(rhs)
            } else if let lhs = self.value.value as? NSArray {
                return lhs.contains(objValue)
            }
            return false

        default:
            return false
        }
    }
}

