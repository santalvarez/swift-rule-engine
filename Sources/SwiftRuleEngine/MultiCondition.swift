//
//  MultiCondition.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 17/09/2023.
//

import Foundation


public struct MultiCondition: Condition {
    public var match: Bool = false
    public var all: [Condition]?
    public var any: [Condition]?
    public var not: Condition?

    public mutating func evaluate(_ obj: Any) throws {
        if self.all != nil {
            try self.evaluateAll(obj)
        } else if self.any != nil {
            try self.evaluateAny(obj)
        } else if self.not != nil {
            try self.evaluateNot(obj)
        }
    }

    private mutating func evaluateAny(_ obj: Any) throws {
        for i in self.any!.indices {
            try self.any![i].evaluate(obj)
            if self.any![i].match {
                self.match = true
                return
            }
        }
    }

    private mutating func evaluateAll(_ obj: Any) throws {
        for i in self.all!.indices {
            try self.all![i].evaluate(obj)
            if !self.all![i].match {
                self.match = false
                return
            }
        }
        self.match = true
    }

    private mutating func evaluateNot(_ obj: Any) throws {
        try self.not!.evaluate(obj)
        self.match = !self.not!.match
    }

    public func evaluateAndMatch(_ obj: Any) throws -> Bool {
        if self.all != nil {
            return try self.evaluateAndMatchAll(obj)
        } else if self.any != nil {
            return try self.evaluateAndMatchAny(obj)
        } else if self.not != nil {
            return try self.evaluateAndMatchNot(obj)
        }
        return false
    }

    private func evaluateAndMatchAny(_ obj: Any) throws -> Bool {
        for condition in self.any! {
            if try condition.evaluateAndMatch(obj) {
                return true
            }
        }
        return false
    }

    private func evaluateAndMatchAll(_ obj: Any) throws -> Bool {
        for condition in self.all! {
            if !(try condition.evaluateAndMatch(obj)) {
                return false
            }
        }
        return true
    }

    private func evaluateAndMatchNot(_ obj: Any) throws -> Bool {
        return !(try self.not!.evaluateAndMatch(obj))
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


