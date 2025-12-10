//
//  MultiCondition.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 17/09/2023.
//

import Foundation


public struct MultiCondition: Condition {
    public var all: [Condition]?
    public var any: [Condition]?
    public var not: Condition?

    public func evaluate(_ obj: Any) throws -> Bool{
        if self.all != nil {
            return try self.evaluateAll(obj)
        } else if self.any != nil {
            return try self.evaluateAny(obj)
        } else if self.not != nil {
            return try self.evaluateNot(obj)
        }
        return false
    }

    private func evaluateAny(_ obj: Any) throws -> Bool {
        for i in self.any!.indices {
            if try self.any![i].evaluate(obj) {
                return true
            }
        }
        return false
    }

    private func evaluateAll(_ obj: Any) throws -> Bool {
        for i in self.all!.indices {
            if !(try self.all![i].evaluate(obj)) {
                return false
            }
        }
        return true
    }

    private func evaluateNot(_ obj: Any) throws -> Bool {
        return !(try self.not!.evaluate(obj))
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.any = try Self.decodeConditionArray(container, .any)
        self.all = try Self.decodeConditionArray(container, .all)
        self.not = try Self.decodeCondition(container, .not)

        guard (any == nil && all == nil && not != nil) ||
              (any == nil && all != nil && not == nil) ||
              (any != nil && all == nil && not == nil) else {
            throw DecodingError.typeMismatch(MultiCondition.self,
                  DecodingError.Context(codingPath: decoder.codingPath,
                                        debugDescription: "Only one of any, all or not should be present"))
        }
    }

    static private func decodeConditionArray(_ container: KeyedDecodingContainer<CodingKeys>, _ key: CodingKeys) throws -> [Condition]? {
        guard container.contains(key) else {
            return nil
        }

        var conditionArray: [Condition] = []
        var conditionArrayContainer = try container.nestedUnkeyedContainer(forKey: key)
        while !conditionArrayContainer.isAtEnd {
            if let condition = try? conditionArrayContainer.decode(MultiCondition.self) {
                conditionArray.append(condition)
            } else if let condition = try? conditionArrayContainer.decode(SimpleCondition.self) {
                conditionArray.append(condition)
            } else {
                throw DecodingError.typeMismatch(Condition.self,
                      DecodingError.Context(codingPath: container.codingPath,
                                            debugDescription: "Missing conditions for multi condition"))
            }
        }
        return conditionArray
    }

    static private func decodeCondition(_ container: KeyedDecodingContainer<CodingKeys>, _ key: CodingKeys) throws -> Condition? {
        guard container.contains(key) else {
            return nil
        }

        if let condition = try? container.decode(MultiCondition.self, forKey: key) {
            return condition
        } else if let condition = try? container.decode(SimpleCondition.self, forKey: key) {
            return condition
        } else {
            throw DecodingError.typeMismatch(Condition.self,
                  DecodingError.Context(codingPath: container.codingPath,
                                        debugDescription: "Missing conditions for multi condition"))
        }
    }

    private enum CodingKeys: String, CodingKey {
        case all, any, not
    }
}


