//
//  ContainsOperatorTests.swift
//  SwiftRuleEngineTests
//
//  Created by Santiago Alvarez on 22/02/2023.
//

import XCTest
@testable import SwiftRuleEngine

class ContainsOperatorTests: XCTestCase {
    func testStringArrayMatch() {
        let lhs = AnyCodable(value: "test", valueType: .string)
        let condition = SimpleCondition(op: "contains", value: lhs)
        let rhs: Any = ["test"]

        let op = Contains()
        
        XCTAssertTrue(op.match(condition, rhs))
    }
    
    func testStringArrayNotMatch() {
        let lhs = AnyCodable(value: "test", valueType: .string)
        let condition = SimpleCondition(op: "contains", value: lhs)
        let rhs: Any = ["foo", "bar"]

        let op = Contains()
        
        XCTAssertFalse(op.match(condition, rhs))
    }

    func testIntArrayMatch() {
        let lhs = AnyCodable(value: 2, valueType: .number)
        let condition = SimpleCondition(op: "contains", value: lhs)
        let rhs: Any = [1, 2, 3]
        
        let op = Contains()
        
        XCTAssertTrue(op.match(condition, rhs))
    }
    
    func testIntArrayNotMatch() {
        let lhs = AnyCodable(value: 4, valueType: .number)
        let condition = SimpleCondition(op: "contains", value: lhs)
        let rhs: Any = [1, 2, 3]
        
        let op = Contains()
        
        XCTAssertFalse(op.match(condition, rhs))
    }
    
    func testDoubleArrayMatch() {
        let lhs = AnyCodable(value: 2.2, valueType: .number)
        let condition = SimpleCondition(op: "contains", value: lhs)
        let rhs: Any = [1.1, 2.2, 3.3]
        
        let op = Contains()
        
        XCTAssertTrue(op.match(condition, rhs))
    }
    
    func testDoubleArrayNotMatch() {
        let lhs = AnyCodable(value: 4.4, valueType: .number)
        let condition = SimpleCondition(op: "contains", value: lhs)
        let rhs: Any = [1.1, 2.2, 3.3]
        
        let op = Contains()
        
        XCTAssertFalse(op.match(condition, rhs))
    }
    
    func testDictionaryArrayMatch() {
        let lhs = AnyCodable(value: ["foo": "bar"], valueType: .dictionary)
        let condition = SimpleCondition(op: "contains", value: lhs)
        let rhs: Any = [["foo": "bar"]]
        
        let op = Contains()
        
        XCTAssertTrue(op.match(condition, rhs))
    }
    
    func testDictionaryArrayNotMatch() {
        let lhs = AnyCodable(value: ["foo": "bar"], valueType: .dictionary)
        let condition = SimpleCondition(op: "contains", value: lhs)
        let rhs: Any = [["foo": 123]]
        
        let op = Contains()
        
        XCTAssertFalse(op.match(condition, rhs))
    }
    
    func testArrayOfArraysMatch() {
        let lhs = AnyCodable(value: [1, 2, 3], valueType: .array)
        let condition = SimpleCondition(op: "contains", value: lhs)
        let rhs: Any = [[1, 2, 3]]
        
        let op = Contains()
        
        XCTAssertTrue(op.match(condition, rhs))
    }
    
    func testArrayOfArraysNotMatch() {
        let lhs = AnyCodable(value: [1, 2, 3], valueType: .array)
        let condition = SimpleCondition(op: "contains", value: lhs)
        let rhs: Any = [[1, 2, 3, 4]]
        
        let op = Contains()
        
        XCTAssertFalse(op.match(condition, rhs))
    }
    
    func testStringsMatch() {
        let lhs = AnyCodable(value: "test", valueType: .string)
        let condition = SimpleCondition(op: "contains", value: lhs)
        let rhs: Any = "xxxx-test-xxxx"
        
        let op = Contains()
        
        XCTAssertTrue(op.match(condition, rhs))
    }
    
    func testStringsNotMatch() {
        let lhs = AnyCodable(value: "foo", valueType: .string)
        let condition = SimpleCondition(op: "contains", value: lhs)
        let rhs: Any = "xxxx-test-xxxx"
        
        let op = Contains()
        
        XCTAssertFalse(op.match(condition, rhs))
    }
    
    func testInvalidType() {
        let lhs = AnyCodable(value: 123123, valueType: .number)
        let condition = SimpleCondition(op: "contains", value: lhs)
        let rhs: Any = 1233
        
        let op = Contains()
        
        XCTAssertFalse(op.match(condition, rhs))
    }
   
}
