//
//  SimpleCondition.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 17/09/2023.
//

import Foundation


public struct SimpleCondition: Condition {
    public let op: Operator
    public let value: AnyCodable
    public let params: [String: Any]?
    public let path: JSONPath?

    public func evaluate(_ obj: Any, cache: inout JSONPathCache) throws -> Bool {
        guard let path = self.path else {
            return op.match(obj)
        }

        if let cached = cache.values[path] {
            return op.match(cached)
        }

        let v = try path.getValue(for: obj)
        cache.values[path] = v
        return op.match(v)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.params = try? container.decode([String: Any].self, forKey: .params)
        self.value =  try container.decode(AnyCodable.self, forKey: .value)

        let operatorRaw = try container.decode(String.self, forKey: .op)

        // Parse decorator chain: "everyFact:everyValue:lessThan" -> ["everyFact", "everyValue", "lessThan"]
        let components = operatorRaw.split(separator: ":").map(String.init)

        guard !components.isEmpty else {
            throw DecodingError.dataCorruptedError(forKey: .op, in: container,
                                                   debugDescription: "Empty operator string")
        }

        // Last component is the actual operator
        let operatorName = components.last!
        let decoratorNames = components.dropLast()

        // Get dictionaries from userInfo
        guard let operatorsDict = decoder.userInfo[operatorsUserInfoKey] as? [String: Operator.Type] else {
            throw DecodingError.dataCorruptedError(forKey: .op, in: container,
                debugDescription: "Operators user info key not provided")
        }

        let decoratorsDict = decoder.userInfo[decoratorsUserInfoKey] as? [String: OperatorDecorator.Type] ?? [:]

        let operatorKey = OperatorID.normalize(operatorName)
        guard let operatorType = operatorsDict[operatorKey] else {
            throw DecodingError.dataCorruptedError(forKey: .op, in: container,
                                                   debugDescription: "Operator \(operatorRaw) not found")
        }

        let decoratorTypes = try decoratorNames.map { decoratorName in
            let decoratorKey = DecoratorID.normalize(decoratorName)
            guard let decoratorType = decoratorsDict[decoratorKey] else {
                throw DecodingError.dataCorruptedError(forKey: .op, in: container,
                                                       debugDescription: "Decorator \(decoratorName) not found")
            }
            return decoratorType
        }

        do {
            self.op = try Self.buildOperator(operatorType: operatorType,
                                             value: self.value,
                                             params: self.params,
                                             decorators: decoratorTypes[...])
        } catch {
            throw DecodingError.dataCorruptedError(forKey: .op, in: container,
                                                   debugDescription: "Error initializing operator \(operatorRaw): \(error)")
        }

        guard let pathStr = try container.decodeIfPresent(String.self, forKey: .path) else {
            self.path = nil
            return
        }
        self.path = try JSONPath(pathStr)
    }

    public init(op: Operator, value: AnyCodable, params: [String: Any]?, path: JSONPath?) {
        self.op = op
        self.value = value
        self.params = params
        self.path = path
    }

    private enum CodingKeys: String, CodingKey {
        case op = "operator", value, params, path
    }

    private static func buildOperator(operatorType: Operator.Type,
                                      value: AnyCodable,
                                      params: [String: Any]?,
                                      decorators: ArraySlice<OperatorDecorator.Type>) throws -> Operator {
        guard let decoratorType = decorators.first else {
            return try operatorType.init(value: value, params: params)
        }

        return try decoratorType.decorate({ innerValue in
            try buildOperator(operatorType: operatorType,
                              value: innerValue,
                              params: params,
                              decorators: decorators.dropFirst())
        }, value: value)
    }
}
