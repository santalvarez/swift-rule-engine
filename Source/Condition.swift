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
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let simpleCondition = try? container.decode(SimpleCondition.self) {
            self = .simple(simpleCondition)
        } else {
            let multiCondition = try container.decode(MultiCondition.self)
            self = .multi(multiCondition)
        }
    }
    
    init(_ value: Any) {
        if value is SimpleCondition{
            self = .simple(value as! SimpleCondition)
        } else {
            self = .multi(value as! MultiCondition)
        }
    }
    
    func getMatch() -> Bool {
        switch self {
        case .simple(let cond):
            return cond.match
        case .multi(let cond):
            return cond.match
        }
    }
}


struct SimpleCondition {
    var match: Bool = false
    var op: String  // operator is reserved
    var value: AnyCodable
    var params: [String: Any]? = nil
    var path: String? = nil
}

extension SimpleCondition: Decodable {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.op = try container.decode(String.self, forKey: .op)
        self.value = try container.decode(AnyCodable.self, forKey: .value)
        self.params = try container.decodeIfPresent([String: AnyCodable].self, forKey: .params)
        self.path = try container.decodeIfPresent(String.self, forKey: .path)
    }
    
    private enum CodingKeys: String, CodingKey {
        case op = "operator", value, params, path
    }
}

struct MultiCondition {
    var match: Bool = false
    var all: [Condition]?
    var any: [Condition]?

    func getConditions() -> [Condition] {
        if self.any != nil {
            return self.any!
        } else {
            return self.all!
        }
    }

    mutating func replaceConditions(_ conditions: [Condition]) {
        if self.any != nil {
            self.any = conditions
        } else {
            self.all = conditions
        }
    }
}

extension MultiCondition: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.any = try container.decodeIfPresent([Condition].self, forKey: .any)
        self.all = try container.decodeIfPresent([Condition].self, forKey: .all)
    }
    
    private enum CodingKeys: String, CodingKey {
        case all, any
    }
}
