//
//  NotContains.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 21/02/2023.
//

import Foundation


struct NotContains: Operator {
    var id = "not_contains"
    
    func match(_ condition: SimpleCondition, _ objValue: Any) -> Bool {
        return true
    }
}
