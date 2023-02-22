//
//  OperatorTests.swift
//  SwiftRuleEngineTests
//
//  Created by Santiago Alvarez on 22/02/2023.
//

import XCTest
@testable import SwiftRuleEngine


class EqualOperatorTests: XCTestCase {

    func testStringsMatch() {
        let lhs = AnyCodable(value: "test", valueType: .string)
        let condition = SimpleCondition(op: "equal", value: lhs)
        let rhs: Any = "test"
        
        let op = Equal()
        
        XCTAssertTrue(op.match(condition, rhs))
    }
    
    func testStringsNotMatch() {
        let lhs = AnyCodable(value: "test", valueType: .string)
        let condition = SimpleCondition(op: "equal", value: lhs)
        let rhs: Any = "not-test"
        
        let op = Equal()
        
        XCTAssertFalse(op.match(condition, rhs))
    }

    func testBoolsMatch() {
        let lhs = AnyCodable(value: true, valueType: .bool)
        let condition = SimpleCondition(op: "equal", value: lhs)
        let rhs: Any = true
        
        let op = Equal()
        
        XCTAssertTrue(op.match(condition, rhs))
    }

     func testBoolsNotMatch() {
        let lhs = AnyCodable(value: true, valueType: .bool)
        let condition = SimpleCondition(op: "equal", value: lhs)
        let rhs: Any = false
        
        let op = Equal()
        
        XCTAssertFalse(op.match(condition, rhs))
    }

    func testIntsMatch() {
        let lhs = AnyCodable(value: 123, valueType: .number)
        let condition = SimpleCondition(op: "equal", value: lhs)
        let rhs: Any = 123
        
        let op = Equal()
        
        XCTAssertTrue(op.match(condition, rhs))
    }
   
    func testIntsNotMatch() {
        let lhs = AnyCodable(value: 123, valueType: .number)
        let condition = SimpleCondition(op: "equal", value: lhs)
        let rhs: Any = 321
        
        let op = Equal()
        
        XCTAssertFalse(op.match(condition, rhs))
    }
    
    func testDoublesMatch() {
        let lhs = AnyCodable(value: 123.123, valueType: .number)
        let condition = SimpleCondition(op: "equal", value: lhs)
        let rhs: Any = 123.123
        
        let op = Equal()
        
        XCTAssertTrue(op.match(condition, rhs))
    }
    
    func testDoublesNotMatch() {
        let lhs = AnyCodable(value: 123.123, valueType: .number)
        let condition = SimpleCondition(op: "equal", value: lhs)
        let rhs: Any = 321.321
        
        let op = Equal()
        
        XCTAssertFalse(op.match(condition, rhs))
    }
    
    func testDictionariesMatch() {
        let lhs = AnyCodable(value: ["foo": "test", "bar": 123], valueType: .dictionary)
        let condition = SimpleCondition(op: "equal", value: lhs)
        let rhs: Any = ["foo": "test", "bar": 123]
        
        let op = Equal()
        
        XCTAssertTrue(op.match(condition, rhs))
    }
    
    func testDictionariesNotMatch() {
        let lhs = AnyCodable(value: ["foo": "test", "bar": 123], valueType: .dictionary)
        let condition = SimpleCondition(op: "equal", value: lhs)
        let rhs: Any = ["foo": "test", "bar": 321]
        
        let op = Equal()
        
        XCTAssertFalse(op.match(condition, rhs))
    }
    
    func testArraysMatch() {
        let lhs = AnyCodable(value: ["foo", "bar"], valueType: .array)
        let condition = SimpleCondition(op: "equal", value: lhs)
        let rhs: Any = ["foo", "bar"]
        
        let op = Equal()
        
        XCTAssertTrue(op.match(condition, rhs))
    }
    
    func testArraysNotMatch() {
        let lhs = AnyCodable(value: ["foo", "bar"], valueType: .array)
        let condition = SimpleCondition(op: "equal", value: lhs)
        let rhs: Any = ["foo"]
        
        let op = Equal()
        
        XCTAssertFalse(op.match(condition, rhs))
    }
    
     func testMultiTypeArraysMatch() {
        let lhs = AnyCodable(value: ["foo", 123], valueType: .array)
        let condition = SimpleCondition(op: "equal", value: lhs)
        let rhs: Any = ["foo", 123]
        
        let op = Equal()
        
        XCTAssertTrue(op.match(condition, rhs))
    }
    
    func testMultiTypeArraysNotMatch() {
        let lhs = AnyCodable(value: ["foo", 123], valueType: .array)
        let condition = SimpleCondition(op: "equal", value: lhs)
        let rhs: Any = ["foo", 321]
        
        let op = Equal()
        
        XCTAssertFalse(op.match(condition, rhs))
    }

    func testNullsMatch() {
        let lhs = AnyCodable(value: NSNull(), valueType: .null)
        let condition = SimpleCondition(op: "equal", value: lhs)
        let rhs: Any = NSNull()
        
        let op = Equal()
        
        XCTAssertTrue(op.match(condition, rhs))
    }
    
    func testNullsNotMatch() {
        let lhs = AnyCodable(value: NSNull(), valueType: .null)
        let condition = SimpleCondition(op: "equal", value: lhs)
        let rhs: Any = "test"
        
        let op = Equal()
        
        XCTAssertFalse(op.match(condition, rhs))
    }

}
