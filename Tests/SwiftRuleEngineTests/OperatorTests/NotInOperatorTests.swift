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
        let op = try! NotIn(value: .array(["foo", "bar"]), params: nil)
        let rhs: Any = "test"

        XCTAssertTrue(op.match(rhs))
    }

    func testStringArrayNotMatch() {
        let op = try! NotIn(value: .array(["test"]), params: nil)
        let rhs: Any = "test"

        XCTAssertFalse(op.match(rhs))
    }

    func testStringArrayAndNilMatch() {
        let op = try! NotIn(value: .array(["test"]), params: nil)
        let rhs: Any? = nil

        XCTAssertTrue(op.match(rhs))
    }

    func testStringArrayAndBoolMatch() {
        let op = try! NotIn(value: .array(["test"]), params: nil)
        let rhs: Any = true

        XCTAssertTrue(op.match(rhs))
    }

    func testIntArrayMatch() {
        let op = try! NotIn(value: .array([1, 2, 3]), params: nil)
        let rhs: Any = 4

        XCTAssertTrue(op.match(rhs))
    }

    func testIntArrayNotMatch() {
        let op = try! NotIn(value: .array([1, 2, 3]), params: nil)
        let rhs: Any = 2

        XCTAssertFalse(op.match(rhs))
    }

    func testDoubleArrayMatch() {
        let op = try! NotIn(value: .array([1.1, 2.2, 3.3]), params: nil)
        let rhs: Any = 4.4

        XCTAssertTrue(op.match(rhs))
    }

    func testDoubleArrayNotMatch() {
        let op = try! NotIn(value: .array([1.1, 2.2, 3.3]), params: nil)
        let rhs: Any = 2.2

        XCTAssertFalse(op.match(rhs))
    }

    func testDictionaryArrayMatch() {
        let op = try! NotIn(value: .array([["foo": "bar"]]), params: nil)
        let rhs: Any = ["foo": 123]

        XCTAssertTrue(op.match(rhs))
    }

    func testDictionaryArrayNotMatch() {
        let op = try! NotIn(value: .array([["foo": "bar"]]), params: nil)
        let rhs: Any = ["foo": "bar"]

        XCTAssertFalse(op.match(rhs))
    }

    func testArrayOfArraysMatch() {
        let op = try! NotIn(value: .array([[1, 2, 3]]), params: nil)
        let rhs: Any = [1, 2, 3, 4]

        XCTAssertTrue(op.match(rhs))
    }

    func testArrayOfArraysNotMatch() {
        let op = try! NotIn(value: .array([[1, 2, 3]]), params: nil)
        let rhs: Any = [1, 2, 3]

        XCTAssertFalse(op.match(rhs))
    }

    func testStringsMatch() {
        let op = try! NotIn(value: .string("xxxx-test-xxxx"), params: nil)
        let rhs: Any = "foo"

        XCTAssertTrue(op.match(rhs))
    }

    func testStringsNotMatch() {
        let op = try! NotIn(value: .string("xxxx-test-xxxx"), params: nil)
        let rhs: Any = "test"

        XCTAssertFalse(op.match(rhs))
    }

    func testInvalidType() {
        XCTAssertThrowsError(try NotIn(value: .number(123123), params: nil))
    }
}
