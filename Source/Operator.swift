//
//  Operator.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 21/12/2022.
//

import Foundation

protocol Operator {
    var id: String { get }
    
    func match()
}
