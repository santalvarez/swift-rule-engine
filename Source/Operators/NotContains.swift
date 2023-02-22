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
        switch condition.value.valueType {
        case .string:
            return true

        case .array:
            return true

        case .bool, .dictionary, .number, .null, .unknown:
            return false
        }
    }
}
