//
//  Contains.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 21/02/2023.
//

import Foundation


struct Contains: Operator {
    var id = "contains"
    
    func match(_ condition: SimpleCondition, _ objValue: Any) -> Bool {
        return true
    }
}

