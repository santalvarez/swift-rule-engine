//
//  OperatorTests.swift
//  SwiftRuleEngineTests
//
//  Created by Santiago Alvarez on 22/02/2023.
//

import XCTest
@testable import SwiftRuleEngine


class LessThanOperatorTests: XCTestCase {

    func testIntsMatch() {
        let lhs = AnyCodable(value: 100, valueType: .number)
        let condition = SimpleCondition(op: .less_than, value: lhs)
        let rhs: Any = 99

        let equalOperator = LessThan()
        
        XCTAssertTrue(equalOperator.match(condition, rhs))
    }

    func testIntsNotMatch() {
        let lhs = AnyCodable(value: 100, valueType: .number)
        let condition = SimpleCondition(op: .less_than, value: lhs)
        let rhs: Any = 101
        
        let equalOperator = LessThan()
        
        XCTAssertFalse(equalOperator.match(condition, rhs))
    }
    
    func testDoublesMatch() {
        let lhs = AnyCodable(value: 100.11, valueType: .number)
        let condition = SimpleCondition(op: .less_than, value: lhs)
        let rhs: Any = 100.09

        let equalOperator = LessThan()
        
        XCTAssertTrue(equalOperator.match(condition, rhs))
    }
    
    func testDoublesNotMatch() {
        let lhs = AnyCodable(value: 100.11, valueType: .number)
        let condition = SimpleCondition(op: .less_than, value: lhs)
        let rhs: Any = 100.13
        
        let equalOperator = LessThan()
        
        XCTAssertFalse(equalOperator.match(condition, rhs))
    }
    
    func testStringsMatch() {
        let lhs = AnyCodable(value: "test", valueType: .string)
        let condition = SimpleCondition(op: .less_than, value: lhs)
        let rhs: Any = "t"

        let equalOperator = LessThan()
        
        XCTAssertTrue(equalOperator.match(condition, rhs))
    }
    
    func testStringsNotMatch() {
        let lhs = AnyCodable(value: "test", valueType: .string)
        let condition = SimpleCondition(op: .less_than, value: lhs)
        let rhs: Any = "test_test"

        let equalOperator = LessThan()
        
        XCTAssertFalse(equalOperator.match(condition, rhs))
    }
    
    func testInvalidType() {
        let lhs = AnyCodable(value: true, valueType: .bool)
        let condition = SimpleCondition(op: .less_than, value: lhs)
        let rhs: Any = false
        
        let equalOperator = LessThan()
        
        XCTAssertFalse(equalOperator.match(condition, rhs))
    }

}
