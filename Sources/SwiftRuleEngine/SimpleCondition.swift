//
//  SimpleCondition.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 17/09/2023.
//

import Foundation


public struct SimpleCondition: Condition {
    public let op: [Operator]
    public let value: AnyCodable
    public let params: [String: Any]?
    public let path: JSONPath?

    public func evaluate(_ obj: Any) throws -> Bool {
        if let path = self.path {
            let obj = try path.getValue(for: obj)
            return op[0].match(obj)
        }
        return op[0].match(obj)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.params = try? container.decode([String: Any].self, forKey: .params)
        self.value =  try container.decode(AnyCodable.self, forKey: .value)

        let operatorID = try container.decode(OperatorID.self, forKey: .op)
        guard let operatorsDict = decoder.userInfo[operatorsUserInfoKey] as? [OperatorID: Operator.Type] else {
            throw DecodingError.dataCorruptedError(forKey: .op, in: container, debugDescription: "Operators user info key not provided")
        }
        guard let operatorType = operatorsDict[operatorID] else {
            throw DecodingError.dataCorruptedError(forKey: .op, in: container, debugDescription: "Operator \(operatorID.rawValue) not found")
        }

        do {
            self.op = [try operatorType.init(value: self.value, params: self.params)]
        } catch {
            throw DecodingError.dataCorruptedError(forKey: .op, in: container, debugDescription: "Error initializing operator \(operatorID.rawValue)")
        }

        guard let pathStr = try container.decodeIfPresent(String.self, forKey: .path) else {
            self.path = nil
            return
        }
        self.path = try JSONPath(pathStr)
    }

    public init(op: [Operator], value: AnyCodable, params: [String: Any]?, path: JSONPath?) {
        self.op = op
        self.value = value
        self.params = params
        self.path = path
    }

    private enum CodingKeys: String, CodingKey {
        case op = "operator", value, params, path
    }
}
