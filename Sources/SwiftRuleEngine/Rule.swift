//
//  Rule.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 21/12/2022.
//

import Foundation


public struct Rule: Decodable {
    public let name: String
    public let description: String?
    public let extra: [String: Any]?
    public var priority: Int
    public var conditions: MultiCondition

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.extra = try? container.decode([String: Any].self, forKey: .extra)
        self.priority = try container.decodeIfPresent(Int.self, forKey: .priority) ?? 1
        self.conditions = try container.decode(MultiCondition.self, forKey: .conditions)
    }

    public enum CodingKeys: String, CodingKey {
        case name, description, extra, priority, conditions
    }

}
