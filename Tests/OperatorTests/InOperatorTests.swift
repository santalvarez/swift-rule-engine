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
        let op = try! In(value: AnyCodable(value: ["test"], valueType: .array), params: nil)
        let rhs: Any = "test"

        XCTAssertTrue(op.match(rhs))
    }

    func testStringArrayNotMatch() {
        let op = try! In(value: AnyCodable(value: ["foo", "bar"], valueType: .array), params: nil)
        let rhs: Any = "test"

        XCTAssertFalse(op.match(rhs))
    }

    func testIntArrayMatch() {
        let op = try! In(value: AnyCodable(value: [1, 2, 3], valueType: .array), params: nil)
        let rhs: Any = 2

        XCTAssertTrue(op.match(rhs))
    }

    func testIntArrayNotMatch() {
        let op = try! In(value: AnyCodable(value: [1, 2, 3], valueType: .array), params: nil)
        let rhs: Any = 4

        XCTAssertFalse(op.match(rhs))
    }

    func testDoubleArrayMatch() {
        let op = try! In(value: AnyCodable(value: [1.1, 2.2, 3.3], valueType: .array), params: nil)
        let rhs: Any = 2.2

        XCTAssertTrue(op.match(rhs))
    }

    func testDoubleArrayNotMatch() {
        let op = try! In(value: AnyCodable(value: [1.1, 2.2, 3.3], valueType: .array), params: nil)
        let rhs: Any = 4.4

        XCTAssertFalse(op.match(rhs))
    }

    func testDictionaryArrayMatch() {
        let op = try! In(value: AnyCodable(value: [["foo": "bar"]], valueType: .array), params: nil)
        let rhs: Any = ["foo": "bar"]

        XCTAssertTrue(op.match(rhs))
    }

    func testDictionaryArrayNotMatch() {
        let op = try! In(value: AnyCodable(value: [["foo": "bar"]], valueType: .array), params: nil)
        let rhs: Any = ["foo": 123]

        XCTAssertFalse(op.match(rhs))
    }

    func testArrayOfArraysMatch() {
        let op = try! In(value: AnyCodable(value: [[1, 2, 3]], valueType: .array), params: nil)
        let rhs: Any = [1, 2, 3]

        XCTAssertTrue(op.match(rhs))
    }

    func testArrayOfArraysNotMatch() {
        let op = try! In(value: AnyCodable(value: [[1, 2, 3]], valueType: .array), params: nil)
        let rhs: Any = [1, 2, 3, 4]

        XCTAssertFalse(op.match(rhs))
    }

    func testStringsMatch() {
        let op = try! In(value: AnyCodable(value: "xxxx-test-xxxx", valueType: .string), params: nil)
        let rhs: Any = "test"

        XCTAssertTrue(op.match(rhs))
    }

    func testStringsNotMatch() {
        let op = try! In(value: AnyCodable(value: "xxxx-test-xxxx", valueType: .string), params: nil)
        let rhs: Any = "foo"

        XCTAssertFalse(op.match(rhs))
    }

    func testInvalidType() {
        let op = try! In(value: AnyCodable(value: 123123, valueType: .array), params: nil)
        let rhs: Any = "test"

        XCTAssertFalse(op.match(rhs))
    }
}
