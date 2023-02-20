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

struct NotEqual: Operator {
    var id = "not_equal"
    
    func match(_ condition: SimpleCondition, _ objValue: Any) -> Bool {
        return true
    }
}

struct LessThan: Operator {
    var id = "less_than"
    
    func match(_ condition: SimpleCondition, _ objValue: Any) -> Bool {
        return true
    }
}

struct LessThanInclusive: Operator {
    var id = "less_than_inclusive"
    
    func match(_ condition: SimpleCondition, _ objValue: Any) -> Bool {
        return true
    }
}

struct GreaterThan: Operator {
    var id = "greater_than"
    
    func match(_ condition: SimpleCondition, _ objValue: Any) -> Bool {
        return true
    }
}

struct GreaterThanInclusive: Operator {
    var id = "greater_than_inclusive"
    
    func match(_ condition: SimpleCondition, _ objValue: Any) -> Bool {
        return true
    }
}

struct In: Operator {
    var id = "in"
    
    func match(_ condition: SimpleCondition, _ objValue: Any) -> Bool {
        return true
    }
}

struct NotIn: Operator {
    var id = "not_in"
    
    func match(_ condition: SimpleCondition, _ objValue: Any) -> Bool {
        return true
    }
}

struct Contains: Operator {
    var id = "contains"
    
    func match(_ condition: SimpleCondition, _ objValue: Any) -> Bool {
        return true
    }
}

struct NotContains: Operator {
    var id = "not_contains"
    
    func match(_ condition: SimpleCondition, _ objValue: Any) -> Bool {
        return true
    }
}
