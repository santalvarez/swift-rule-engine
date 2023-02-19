//
//  Rule.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 21/12/2022.
//

import Foundation


struct Rule: Decodable {
    let name: String
    let description: String?
    let extra: [String: Any]?
    let conditions: MultiCondition
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try container.decode(String?.self, forKey: .description)
        // TODO: maybe make this any??
        self.extra = try container.decode([String: AnyCodable]?.self, forKey: .extra)
        self.conditions = try container.decode(MultiCondition.self, forKey: .conditions)
    }
    
    private enum CodingKeys: String, CodingKey {
        case name, description, extra, conditions
    }
    
}
