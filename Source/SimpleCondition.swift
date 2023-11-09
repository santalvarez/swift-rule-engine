//
//  SimpleCondition.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 17/09/2023.
//

import Foundation


public struct SimpleCondition {
    public var match: Bool = false
    public var op: Operator  // operator kw is reserved
    public var value: AnyCodable
    public var params: [String: Any]? = nil
    public var path: JSONPath? = nil
}

extension SimpleCondition: Decodable {

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
            self.op = try operatorType.init(value: self.value, params: self.params)
        } catch {
            throw DecodingError.dataCorruptedError(forKey: .op, in: container, debugDescription: "Error initializing operator \(operatorID.rawValue)")
        }

        if let pathStr = try container.decodeIfPresent(String.self, forKey: .path) {
            self.path = try JSONPath(pathStr)
        }
    }

    private enum CodingKeys: String, CodingKey {
        case op = "operator", value, params, path
    }
}
