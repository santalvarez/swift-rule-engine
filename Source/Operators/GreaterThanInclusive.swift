//
//  GreaterThanInclusive.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 21/02/2023.
//

import Foundation


struct GreaterThanInclusive: Operator {
    var id = "greater_than_inclusive"
    
    func match(_ condition: SimpleCondition, _ objValue: Any) -> Bool {
        return true
    }
}

