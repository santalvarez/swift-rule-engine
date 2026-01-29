//
//  Condition.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 21/12/2022.
//

import Foundation

public protocol Condition: Decodable {
    func evaluate(_ obj: Any, cache: inout JSONPathCache) throws -> Bool
}
