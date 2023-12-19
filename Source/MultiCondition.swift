//
//  MultiCondition.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 17/09/2023.
//

import Foundation


public struct MultiCondition {
    public var match: Bool = false
    public var all: [Condition]?
    public var any: [Condition]?
    public var not: Condition?
}

extension MultiCondition: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.any = try container.decodeIfPresent([Condition].self, forKey: .any)
        self.all = try container.decodeIfPresent([Condition].self, forKey: .all)
        self.not = try container.decodeIfPresent(Condition.self, forKey: .not)
        if self.any == nil && self.all == nil && self.not == nil {
            throw DecodingError.typeMismatch(MultiCondition.self,
                  DecodingError.Context(codingPath: decoder.codingPath,
                                        debugDescription: "Missing conditions for multi condition"))
        }
    }

    private enum CodingKeys: String, CodingKey {
        case all, any, not
    }
}
