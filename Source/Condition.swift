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
}
