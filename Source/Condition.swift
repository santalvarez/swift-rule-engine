//
//  Condition.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 21/12/2022.
//

import Foundation

enum Condition: Decodable {
    case simple(SimpleCondition)
    case multi(MultiCondition)
}


struct SimpleCondition {
    var match: Bool = false
    var op: String  // operator is reserved
    var value: AnyCodable
    var params: [String: Any] = [:]
    var path: String? = nil
}

extension SimpleCondition: Decodable {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.op = try container.decode(String.self, forKey: .op)
        self.value = try container.decode(AnyCodable.self, forKey: .value)
        self.params = try container.decode([String: AnyCodable].self, forKey: .params)
        self.path = try container.decodeIfPresent(String.self, forKey: .path)
    }
    
    private enum CodingKeys: String, CodingKey {
        case op = "operator", value, params, path
    }
}

struct MultiCondition {
    var match: Bool = false
    var all: [Condition] = []
    var any: [Condition] = []
}

extension MultiCondition: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.any = try container.decode([Condition].self, forKey: .any)
        self.all = try container.decode([Condition].self, forKey: .all)
    }
    
    private enum CodingKeys: String, CodingKey {
        case all, any
    }
}
