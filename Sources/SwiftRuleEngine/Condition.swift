//
//  Condition.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 21/12/2022.
//

import Foundation

public protocol Condition: Decodable {
    var match: Bool { get set }

    mutating func evaluate(_ obj: Any) throws

    /// Non-mutating evaluation that returns the match result directly
    /// This avoids the need to mutate the condition and improves performance
    func evaluateAndMatch(_ obj: Any) throws -> Bool
}
