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
        case .regex, .contains_regex, .not_contains_regex:
            guard let pattern = try self.decodeIfPresent(String.self, forKey: key) else {
                throw DecodingError.typeMismatch(String.self,
                      DecodingError.Context(codingPath: codingPath,
                                            debugDescription: "Missing pattern for regex operator"))
            }

            return AnyCodable(value: try NSRegularExpression(pattern: pattern), valueType: .regex)

        case .in_set, .not_in_set:
            if let set = try self.decodeIfPresent(Set<String>.self, forKey: key) {
                return AnyCodable(value: set, valueType: .set)

            } else if let set = try self.decodeIfPresent(Set<Int>.self, forKey: key) {
                return AnyCodable(value: set, valueType: .set)

            } else if let set = try self.decodeIfPresent(Set<Double>.self, forKey: key) {
                return AnyCodable(value: set, valueType: .set)
            } else {
                throw DecodingError.typeMismatch(Set<Double>.self,
                      DecodingError.Context(codingPath: codingPath,
                                            debugDescription: "Missing set for set operator"))
            }
        default:
            return try self.decode(AnyCodable.self, forKey: key)
        }
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
        if let container = try? decoder.container(keyedBy: JSONCodingKeys.self) {
            if let dictionary = try? container.decode([String: Any].self) {
                self.value = dictionary
                self.valueType = .dictionary
            } else {
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: container.codingPath, debugDescription: "AnyCodable value cannot be decoded"))
            }
            return
        }

        if var container = try? decoder.unkeyedContainer() {
            if let array = try? container.decode([Any].self) {
                self.value = array
                self.valueType = .array
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "AnyCodable value cannot be decoded")
            }
            return
        }

        if let container = try? decoder.singleValueContainer(){
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
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "AnyCodable value cannot be decoded")
            }
            return
        }

        throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Could not initialize container"))
    }
}
