//
//  GreaterThanOperatorTests.swift
//  SwiftRuleEngineTests
//
//  Created by Santiago Alvarez on 22/02/2023.
//

import XCTest
@testable import SwiftRuleEngine


class GreaterThanOperatorTests: XCTestCase {

    func testIntsMatch() {
        let lhs = AnyCodable(value: 99, valueType: .number)
        let condition = SimpleCondition(op: .greater_than, value: lhs)
        let rhs: Any = 100

        let op = GreaterThan()

        XCTAssertTrue(op.match(condition, rhs))
    }

    func testIntsNotMatch() {
        let lhs = AnyCodable(value: 100, valueType: .number)
        let condition = SimpleCondition(op: .greater_than, value: lhs)
        let rhs: Any = 99
        
        let op = GreaterThan()
        
        XCTAssertFalse(op.match(condition, rhs))
    }
    
    func testDoublesMatch() {
        let lhs = AnyCodable(value: 100.11, valueType: .number)
        let condition = SimpleCondition(op: .greater_than, value: lhs)
        let rhs: Any = 100.13

        let op = GreaterThan()
        
        XCTAssertTrue(op.match(condition, rhs))
    }
    
    func testDoublesNotMatch() {
        let lhs = AnyCodable(value: 100.13, valueType: .number)
        let condition = SimpleCondition(op: .greater_than, value: lhs)
        let rhs: Any = 100.11
        
        let op = GreaterThan()
        
        XCTAssertFalse(op.match(condition, rhs))
    }
    
    func testStringsMatch() {
        let lhs = AnyCodable(value: "t", valueType: .string)
        let condition = SimpleCondition(op: .greater_than, value: lhs)
        let rhs: Any = "test"

        let op = GreaterThan()
        
        XCTAssertTrue(op.match(condition, rhs))
    }
    
    func testStringsNotMatch() {
        let lhs = AnyCodable(value: "test_test", valueType: .string)
        let condition = SimpleCondition(op: .greater_than, value: lhs)
        let rhs: Any = "test"

        let op = GreaterThan()
        
        XCTAssertFalse(op.match(condition, rhs))
    }
    
    func testInvalidType() {
        let lhs = AnyCodable(value: true, valueType: .bool)
        let condition = SimpleCondition(op: .greater_than, value: lhs)
        let rhs: Any = false
        
        let op = GreaterThan()
        
        XCTAssertFalse(op.match(condition, rhs))
    }

}
