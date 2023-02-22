//
//  NotContains.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 21/02/2023.
//

import Foundation


struct NotContains: Operator {
    let id = "not_contains"
    
    func match(_ condition: SimpleCondition, _ objValue: Any) -> Bool {
        if let rhs = objValue as? NSArray {
            return !rhs.contains(condition.value.value)
        }
        
        if let rhs = objValue as? String,
           let lhs = condition.value.value as? String {
            return !rhs.contains(lhs)
        }

        return false
    }
}
