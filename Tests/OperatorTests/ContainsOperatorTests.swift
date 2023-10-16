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
        let op = try! Contains(value: AnyCodable(value: "test", valueType: .string), params: nil)
        let rhs: Any = ["test"]

        XCTAssertTrue(op.match(rhs))
    }

    func testStringArrayNotMatch() {
        let op = try! Contains(value: AnyCodable(value: "test", valueType: .string), params: nil)
        let rhs: Any = ["foo", "bar"]

        XCTAssertFalse(op.match(rhs))
    }

    func testIntArrayMatch() {
        let op = try! Contains(value: AnyCodable(value: 2, valueType: .number), params: nil)
        let rhs: Any = [1, 2, 3]

        XCTAssertTrue(op.match(rhs))
    }

    func testIntArrayNotMatch() {
        let op = try! Contains(value: AnyCodable(value: 4, valueType: .number), params: nil)
        let rhs: Any = [1, 2, 3]

        XCTAssertFalse(op.match(rhs))
    }

    func testDoubleArrayMatch() {
        let op = try! Contains(value: AnyCodable(value: 2.2, valueType: .number), params: nil)
        let rhs: Any = [1.1, 2.2, 3.3]

        XCTAssertTrue(op.match(rhs))
    }

    func testDoubleArrayNotMatch() {
        let op = try! Contains(value: AnyCodable(value: 4.4, valueType: .number), params: nil)
        let rhs: Any = [1.1, 2.2, 3.3]

        XCTAssertFalse(op.match(rhs))
    }

    func testDictionaryArrayMatch() {
        let op = try! Contains(value: AnyCodable(value: ["foo": "bar"], valueType: .dictionary), params: nil)
        let rhs: Any = [["foo": "bar"]]

        XCTAssertTrue(op.match(rhs))
    }

    func testDictionaryArrayNotMatch() {
        let op = try! Contains(value: AnyCodable(value: ["foo": "bar"], valueType: .dictionary), params: nil)
        let rhs: Any = [["foo": 123]]

        XCTAssertFalse(op.match(rhs))
    }

    func testArrayOfArraysMatch() {
        let op = try! Contains(value: AnyCodable(value: [1, 2, 3], valueType: .array), params: nil)
        let rhs: Any = [[1, 2, 3]]

        XCTAssertTrue(op.match(rhs))
    }

    func testArrayOfArraysNotMatch() {
        let op = try! Contains(value: AnyCodable(value: [1, 2, 3], valueType: .array), params: nil)
        let rhs: Any = [[1, 2, 3, 4]]

        XCTAssertFalse(op.match(rhs))
    }

    func testStringsMatch() {
        let op = try! Contains(value: AnyCodable(value: "test", valueType: .string), params: nil)
        let rhs: Any = "xxxx-test-xxxx"

        XCTAssertTrue(op.match(rhs))
    }

    func testStringsNotMatch() {
        let op = try! Contains(value: AnyCodable(value: "foo", valueType: .string), params: nil)
        let rhs: Any = "xxxx-test-xxxx"

        XCTAssertFalse(op.match(rhs))
    }

    func testInvalidType() {
        let op = try! Contains(value: AnyCodable(value: 123123, valueType: .number), params: nil)
        let rhs: Any = 1233

        XCTAssertFalse(op.match(rhs))
    }

}
