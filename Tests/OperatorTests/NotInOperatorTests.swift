//
//  NotInOperatorTests.swift
//  SwiftRuleEngineTests
//
//  Created by Santiago Alvarez on 22/02/2023.
//

import XCTest
@testable import SwiftRuleEngine


class NotInOperatorTests: XCTestCase {

    func testStringArrayMatch() {
        let op = try! NotIn(value: AnyCodable(value: ["foo", "bar"], valueType: .array), params: nil)
        let rhs: Any = "test"

        XCTAssertTrue(op.match(rhs))
    }

    func testStringArrayNotMatch() {
        let op = try! NotIn(value: AnyCodable(value: ["test"], valueType: .array), params: nil)
        let rhs: Any = "test"

        XCTAssertFalse(op.match(rhs))
    }

    func testIntArrayMatch() {
        let op = try! NotIn(value: AnyCodable(value: [1, 2, 3], valueType: .array), params: nil)
        let rhs: Any = 4

        XCTAssertTrue(op.match(rhs))
    }

    func testIntArrayNotMatch() {
        let op = try! NotIn(value: AnyCodable(value: [1, 2, 3], valueType: .array), params: nil)
        let rhs: Any = 2

        XCTAssertFalse(op.match(rhs))
    }

    func testDoubleArrayMatch() {
        let op = try! NotIn(value: AnyCodable(value: [1.1, 2.2, 3.3], valueType: .array), params: nil)
        let rhs: Any = 4.4

        XCTAssertTrue(op.match(rhs))
    }

    func testDoubleArrayNotMatch() {
        let op = try! NotIn(value: AnyCodable(value: [1.1, 2.2, 3.3], valueType: .array), params: nil)
        let rhs: Any = 2.2

        XCTAssertFalse(op.match(rhs))
    }

    func testDictionaryArrayMatch() {
        let op = try! NotIn(value: AnyCodable(value: [["foo": "bar"]], valueType: .array), params: nil)
        let rhs: Any = ["foo": 123]

        XCTAssertTrue(op.match(rhs))
    }

    func testDictionaryArrayNotMatch() {
        let op = try! NotIn(value: AnyCodable(value: [["foo": "bar"]], valueType: .array), params: nil)
        let rhs: Any = ["foo": "bar"]

        XCTAssertFalse(op.match(rhs))
    }

    func testArrayOfArraysMatch() {
        let op = try! NotIn(value: AnyCodable(value: [[1, 2, 3]], valueType: .array), params: nil)
        let rhs: Any = [1, 2, 3, 4]

        XCTAssertTrue(op.match(rhs))
    }

    func testArrayOfArraysNotMatch() {
        let op = try! NotIn(value: AnyCodable(value: [[1, 2, 3]], valueType: .array), params: nil)
        let rhs: Any = [1, 2, 3]

        XCTAssertFalse(op.match(rhs))
    }

    func testStringsMatch() {
        let op = try! NotIn(value: AnyCodable(value: "xxxx-test-xxxx", valueType: .string), params: nil)
        let rhs: Any = "foo"

        XCTAssertTrue(op.match(rhs))
    }

    func testStringsNotMatch() {
        let op = try! NotIn(value: AnyCodable(value: "xxxx-test-xxxx", valueType: .string), params: nil)
        let rhs: Any = "test"

        XCTAssertFalse(op.match(rhs))
    }

    func testInvalidType() {
        let op = try! NotIn(value: AnyCodable(value: 123123, valueType: .array), params: nil)
        let rhs: Any = "test"

        XCTAssertFalse(op.match(rhs))
    }
}
