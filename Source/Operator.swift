//
//  Operator.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 21/12/2022.
//

import Foundation


protocol Operator {
    var id: String { get }
    
    func match(condition: SimpleCondition, objValue: AnyCodable) -> Bool
}


struct Equal: Operator {
    var id = "equal"
    
    func match(condition: SimpleCondition, objValue: AnyCodable) -> Bool {
        return true
    }
}
