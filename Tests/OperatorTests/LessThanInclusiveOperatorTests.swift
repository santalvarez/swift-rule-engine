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
        let op = try! LessThanInclusive(value: AnyCodable(value: 100, valueType: .number), params: nil)
        let rhs: Any = 99

        XCTAssertTrue(op.match(rhs))
    }

    func testIntsMatchInclusive() {
        let op = try! LessThanInclusive(value: AnyCodable(value: 100, valueType: .number), params: nil)
        let rhs: Any = 100

        XCTAssertTrue(op.match(rhs))
    }

    func testIntsNotMatch() {
        let op = try! LessThanInclusive(value: AnyCodable(value: 100, valueType: .number), params: nil)
        let rhs: Any = 101

        XCTAssertFalse(op.match(rhs))
    }

    func testDoublesMatch() {
        let op = try! LessThanInclusive(value: AnyCodable(value: 100.11, valueType: .number), params: nil)
        let rhs: Any = 100.09

        XCTAssertTrue(op.match(rhs))
    }

    func testDoublesMatchInclusive() {
        let op = try! LessThanInclusive(value: AnyCodable(value: 100.11, valueType: .number), params: nil)
        let rhs: Any = 100.11

        XCTAssertTrue(op.match(rhs))
    }

    func testDoublesNotMatch() {
        let op = try! LessThanInclusive(value: AnyCodable(value: 100.11, valueType: .number), params: nil)
        let rhs: Any = 100.13

        XCTAssertFalse(op.match(rhs))
    }

    func testStringsMatch() {
        let op = try! LessThanInclusive(value: AnyCodable(value: "test", valueType: .string), params: nil)
        let rhs: Any = "t"

        XCTAssertTrue(op.match(rhs))
    }

    func testStringsNotMatch() {
        let op = try! LessThanInclusive(value: AnyCodable(value: "test", valueType: .string), params: nil)
        let rhs: Any = "test_test"

        XCTAssertFalse(op.match(rhs))
    }

    func testStringsMatchInclusive() {
        let op = try! LessThanInclusive(value: AnyCodable(value: "test", valueType: .string), params: nil)
        let rhs: Any = "test"

        XCTAssertTrue(op.match(rhs))
    }

    func testInvalidType() {
        let op = try! LessThanInclusive(value: AnyCodable(value: true, valueType: .bool), params: nil)
        let rhs: Any = false

        XCTAssertFalse(op.match(rhs))
    }

}
