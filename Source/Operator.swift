//
//  Operator.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 21/12/2022.
//

import Foundation


protocol Operator {
    var id: String { get }
    
    func match(_ condition: SimpleCondition, _ objValue: Any) -> Bool
}


struct Equal: Operator {
    var id = "equal"
    
    func match(_ condition: SimpleCondition, _ objValue: Any) -> Bool {
        return true
    }
}
