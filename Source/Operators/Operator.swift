//
//  Operator.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 21/12/2022.
//

import Foundation


public protocol Operator {
    var id: String { get }
    
    func match(_ condition: SimpleCondition, _ objValue: Any) -> Bool
}

