//
//  InOperatorTests.swift
//  SwiftRuleEngineTests
//
//  Created by Santiago Alvarez on 22/02/2023.
//

import XCTest
@testable import SwiftRuleEngine


class InOperatorTests: XCTestCase {

    func testStringArrayMatch() {
        let lhs = AnyCodable(value: ["test"], valueType: .array)
        let condition = SimpleCondition(op: .in_, value: lhs)
        let rhs: Any = "test"
        
        let op = In()
        
        XCTAssertTrue(op.match(condition, rhs))
    }
    
    func testStringArrayNotMatch() {
        let lhs = AnyCodable(value: ["foo", "bar"], valueType: .array)
        let condition = SimpleCondition(op: .in_, value: lhs)
        let rhs: Any = "test"
        
        let op = In()
        
        XCTAssertFalse(op.match(condition, rhs))
    }
    
    func testIntArrayMatch() {
        let lhs = AnyCodable(value: [1, 2, 3], valueType: .array)
        let condition = SimpleCondition(op: .in_, value: lhs)
        let rhs: Any = 2
        
        let op = In()
        
        XCTAssertTrue(op.match(condition, rhs))
    }
    
    func testIntArrayNotMatch() {
        let lhs = AnyCodable(value: [1, 2, 3], valueType: .array)
        let condition = SimpleCondition(op: .in_, value: lhs)
        let rhs: Any = 4
        
        let op = In()
        
        XCTAssertFalse(op.match(condition, rhs))
    }
    
    func testDoubleArrayMatch() {
        let lhs = AnyCodable(value: [1.1, 2.2, 3.3], valueType: .array)
        let condition = SimpleCondition(op: .in_, value: lhs)
        let rhs: Any = 2.2
        
        let op = In()
        
        XCTAssertTrue(op.match(condition, rhs))
    }
    
    func testDoubleArrayNotMatch() {
        let lhs = AnyCodable(value: [1.1, 2.2, 3.3], valueType: .array)
        let condition = SimpleCondition(op: .in_, value: lhs)
        let rhs: Any = 4.4
        
        let op = In()
        
        XCTAssertFalse(op.match(condition, rhs))
    }
    
    func testDictionaryArrayMatch() {
        let lhs = AnyCodable(value: [["foo": "bar"]], valueType: .array)
        let condition = SimpleCondition(op: .in_, value: lhs)
        let rhs: Any = ["foo": "bar"]
        
        let op = In()
        
        XCTAssertTrue(op.match(condition, rhs))
    }
    
    func testDictionaryArrayNotMatch() {
        let lhs = AnyCodable(value: [["foo": "bar"]], valueType: .array)
        let condition = SimpleCondition(op: .in_, value: lhs)
        let rhs: Any = ["foo": 123]
        
        let op = In()
        
        XCTAssertFalse(op.match(condition, rhs))
    }
    
    func testArrayOfArraysMatch() {
        let lhs = AnyCodable(value: [[1, 2, 3]], valueType: .array)
        let condition = SimpleCondition(op: .in_, value: lhs)
        let rhs: Any = [1, 2, 3]
        
        let op = In()
        
        XCTAssertTrue(op.match(condition, rhs))
    }
    
    func testArrayOfArraysNotMatch() {
        let lhs = AnyCodable(value: [[1, 2, 3]], valueType: .array)
        let condition = SimpleCondition(op: .in_, value: lhs)
        let rhs: Any = [1, 2, 3, 4]
        
        let op = In()
        
        XCTAssertFalse(op.match(condition, rhs))
    }
    
    func testStringsMatch() {
        let lhs = AnyCodable(value: "xxxx-test-xxxx", valueType: .string)
        let condition = SimpleCondition(op: .in_, value: lhs)
        let rhs: Any = "test"
        
        let op = In()
        
        XCTAssertTrue(op.match(condition, rhs))
    }
    
    func testStringsNotMatch() {
        let lhs = AnyCodable(value: "xxxx-test-xxxx", valueType: .string)
        let condition = SimpleCondition(op: .in_, value: lhs)
        let rhs: Any = "foo"
        
        let op = In()
        
        XCTAssertFalse(op.match(condition, rhs))
    }
    
    func testInvalidType() {
        let lhs = AnyCodable(value: 123123, valueType: .array)
        let condition = SimpleCondition(op: .in_, value: lhs)
        let rhs: Any = "test"
        
        let op = In()
        
        XCTAssertFalse(op.match(condition, rhs))
    }
}
