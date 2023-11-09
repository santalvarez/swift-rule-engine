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
        let op = try! GreaterThan(value: AnyCodable(value: 99, valueType: .number), params: nil)
        let rhs: Any = 100

        XCTAssertTrue(op.match(rhs))
    }

    func testIntsNotMatch() {
        let op = try! GreaterThan(value: AnyCodable(value: 100, valueType: .number), params: nil)
        let rhs: Any = 99

        XCTAssertFalse(op.match(rhs))
    }

    func testDoublesMatch() {
        let op = try! GreaterThan(value: AnyCodable(value: 100.11, valueType: .number), params: nil)
        let rhs: Any = 100.13

        XCTAssertTrue(op.match(rhs))
    }

    func testDoublesNotMatch() {
        let op = try! GreaterThan(value: AnyCodable(value: 100.13, valueType: .number), params: nil)
        let rhs: Any = 100.11

        XCTAssertFalse(op.match(rhs))
    }

    func testStringsMatch() {
        let op = try! GreaterThan(value: AnyCodable(value: "t", valueType: .string), params: nil)
        let rhs: Any = "test"

        XCTAssertTrue(op.match(rhs))
    }

    func testStringsNotMatch() {
        let op = try! GreaterThan(value: AnyCodable(value: "test_test", valueType: .string), params: nil)
        let rhs: Any = "test"

        XCTAssertFalse(op.match(rhs))
    }

    func testInvalidType() {
        let op = try! GreaterThan(value: AnyCodable(value: true, valueType: .bool), params: nil)
        let rhs: Any = false

        XCTAssertFalse(op.match(rhs))
    }

}
