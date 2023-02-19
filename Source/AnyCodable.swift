//
//  AnyCodable.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 21/12/2022.
//

import Foundation

enum Type: Int {
    case number
    case string
    case bool
    case array
    case dictionary
    case null
    case unknown
}

struct AnyCodable: Decodable {
    var value: Any
    var valueType: Type

    init(from decoder: Decoder) throws {
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
            // TODO: also watch out for this
            self.value = dictionary
            self.valueType = .dictionary

        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "AnyCodable value cannot be decoded")
        }
    }
}
