//
//  NotIn.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 21/02/2023.
//

import Foundation

struct NotIn: Operator {
    var id = "not_in"
    
    func match(_ condition: SimpleCondition, _ objValue: Any) -> Bool {
        return true
    }
}
