//
//  GreaterThan.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 21/02/2023.
//

import Foundation

struct GreaterThan: Operator {
    var id = "greater_than"
    
    func match(_ condition: SimpleCondition, _ objValue: Any) -> Bool {
        return true
    }
}

