//
//  LessThanInclusiveOperatorTests.swift
//  SwiftRuleEngineTests
//
//  Created by Santiago Alvarez on 22/02/2023.
//

import XCTest
@testable import SwiftRuleEngine

class LessThanInclusiveOperatorTests: XCTestCase {
    func testIntsMatch() {
        let lhs = AnyCodable(value: 100, valueType: .number)
        let condition = SimpleCondition(op: "less_than_inclusive", value: lhs)
        let rhs: Any = 99

        let op = LessThanInclusive()

        XCTAssertTrue(op.match(condition, rhs))
    }
    
    func testIntsMatchInclusive() {
        let lhs = AnyCodable(value: 100, valueType: .number)
        let condition = SimpleCondition(op: "less_than_inclusive", value: lhs)
        let rhs: Any = 100

        let op = LessThanInclusive()

        XCTAssertTrue(op.match(condition, rhs))
    }

    func testIntsNotMatch() {
        let lhs = AnyCodable(value: 100, valueType: .number)
        let condition = SimpleCondition(op: "less_than_inclusive", value: lhs)
        let rhs: Any = 101
        
        let op = LessThanInclusive()
        
        XCTAssertFalse(op.match(condition, rhs))
    }
    
    func testDoublesMatch() {
        let lhs = AnyCodable(value: 100.11, valueType: .number)
        let condition = SimpleCondition(op: "less_than_inclusive", value: lhs)
        let rhs: Any = 100.09

        let op = LessThanInclusive()
        
        XCTAssertTrue(op.match(condition, rhs))
    }
    
    func testDoublesMatchInclusive() {
        let lhs = AnyCodable(value: 100.11, valueType: .number)
        let condition = SimpleCondition(op: "less_than_inclusive", value: lhs)
        let rhs: Any = 100.11

        let op = LessThanInclusive()
        
        XCTAssertTrue(op.match(condition, rhs))
    }
       
    func testDoublesNotMatch() {
        let lhs = AnyCodable(value: 100.11, valueType: .number)
        let condition = SimpleCondition(op: "less_than_inclusive", value: lhs)
        let rhs: Any = 100.13
        
        let op = LessThanInclusive()
        
        XCTAssertFalse(op.match(condition, rhs))
    }
    
    func testStringsMatch() {
        let lhs = AnyCodable(value: "test", valueType: .string)
        let condition = SimpleCondition(op: "less_than_inclusive", value: lhs)
        let rhs: Any = "t"

        let op = LessThanInclusive()
        
        XCTAssertTrue(op.match(condition, rhs))
    }
    
    func testStringsNotMatch() {
        let lhs = AnyCodable(value: "test", valueType: .string)
        let condition = SimpleCondition(op: "less_than_inclusive", value: lhs)
        let rhs: Any = "test_test"

        let op = LessThanInclusive()
        
        XCTAssertFalse(op.match(condition, rhs))
    }
    
    func testStringsMatchInclusive() {
        let lhs = AnyCodable(value: "test", valueType: .string)
        let condition = SimpleCondition(op: "less_than_inclusive", value: lhs)
        let rhs: Any = "test"

        let op = LessThanInclusive()
        
        XCTAssertTrue(op.match(condition, rhs))
    }
    
    func testInvalidType() {
        let lhs = AnyCodable(value: true, valueType: .bool)
        let condition = SimpleCondition(op: "less_than_inclusive", value: lhs)
        let rhs: Any = false
        
        let op = LessThanInclusive()
        
        XCTAssertFalse(op.match(condition, rhs))
    }

}
