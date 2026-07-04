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

    public func evaluate(_ obj: Any, cache: inout JSONPathCache) throws -> Bool {
        if let all = self.all {
            for c in all {
                if !(try c.evaluate(obj, cache: &cache)) { return false }
            }
            return true
        } else if let any = self.any {
            for c in any {
                if try c.evaluate(obj, cache: &cache) { return true }
            }
            return false
        } else if let not = self.not {
            return !(try not.evaluate(obj, cache: &cache))
        }
        return false
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
            let condition = try conditionArrayContainer.decode(AnyCondition.self)
            conditionArray.append(condition.condition)
        }
        return conditionArray
    }

    static private func decodeCondition(_ container: KeyedDecodingContainer<CodingKeys>, _ key: CodingKeys) throws -> Condition? {
        guard container.contains(key) else {
            return nil
        }

        return try container.decode(AnyCondition.self, forKey: key).condition
    }

    private enum CodingKeys: String, CodingKey {
        case all, any, not
    }

    private struct AnyCondition: Decodable {
        let condition: Condition

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            if container.contains(.all) || container.contains(.any) || container.contains(.not) {
                self.condition = try MultiCondition(from: decoder)
            } else {
                self.condition = try SimpleCondition(from: decoder)
            }
        }
    }
}


