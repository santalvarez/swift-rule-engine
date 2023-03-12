//
//  AnyCodable.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 21/12/2022.
//

import Foundation


extension KeyedDecodingContainer {


    func decodeConditionValue(forKey key: KeyedDecodingContainer<K>.Key, forOperator op: OperatorID) throws -> AnyCodable {

        switch op {
        case .regex:
            // NOTE: how can i obtain the pattern
            guard let pattern = try self.decodeIfPresent(String.self, forKey: key) else {
                throw DecodingError.typeMismatch(String.self, DecodingError.Context(codingPath: codingPath, debugDescription: "Missing pattern for regex operator"))
            }

            return AnyCodable(value: try NSRegularExpression(pattern: pattern), valueType: .regex)
        default:
            break
        }

        return try self.decode(AnyCodable.self, forKey: key)
    }
}


public enum VType: Int {
    case number
    case string
    case bool
    case array
    case dictionary
    case null
    case regex
    case set
    case unknown
}

public struct AnyCodable: Decodable {
    public let value: Any
    public let valueType: VType

    init(value: Any, valueType: VType) {
        self.value = value
        self.valueType = valueType
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() {
            self.value = NSNull()
            self.valueType = .null

        } else if let string = try? container.decode(String.self) {
            self.value = string
            self.valueType = .string

        } else if let bool = try? container.decode(Bool.self) {
            self.value = bool
            self.valueType = .bool

        } else if let int = try? container.decode(Int.self) {
            self.value = int
            self.valueType = .number

        } else if let double = try? container.decode(Double.self) {
            self.value = double
            self.valueType = .number

        } else if let array = try? container.decode([AnyCodable].self) {
            // TODO: watch out for this
            self.value = array
            self.valueType = .array

        } else if let dictionary = try? container.decode([String: AnyCodable].self) {
            self.value = dictionary
            self.valueType = .dictionary

        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "AnyCodable value cannot be decoded")
        }
    }
}
