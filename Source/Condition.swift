//
//  Condition.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 21/12/2022.
//

import Foundation

public indirect enum Condition: Decodable {
    case simple(SimpleCondition)
    case multi(MultiCondition)

    public init(from decoder: Decoder) throws {
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
