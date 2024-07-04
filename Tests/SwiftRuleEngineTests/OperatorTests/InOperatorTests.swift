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
        let op = try! In(value: .array(["test"]), params: nil)
        let rhs: Any = "test"

        XCTAssertTrue(op.match(rhs))
    }

    func testStringArrayNotMatch() {
        let op = try! In(value: .array(["foo", "bar"]), params: nil)
        let rhs: Any = "test"

        XCTAssertFalse(op.match(rhs))
    }

    func testIntArrayMatch() {
        let op = try! In(value: .array([1, 2, 3]), params: nil)
        let rhs: Any = 2

        XCTAssertTrue(op.match(rhs))
    }

    func testIntArrayNotMatch() {
        let op = try! In(value: .array([1, 2, 3]), params: nil)
        let rhs: Any = 4

        XCTAssertFalse(op.match(rhs))
    }

    func testDoubleArrayMatch() {
        let op = try! In(value: .array([1.1, 2.2, 3.3]), params: nil)
        let rhs: Any = 2.2

        XCTAssertTrue(op.match(rhs))
    }

    func testDoubleArrayNotMatch() {
        let op = try! In(value: .array([1.1, 2.2, 3.3]), params: nil)
        let rhs: Any = 4.4

        XCTAssertFalse(op.match(rhs))
    }

    func testDictionaryArrayMatch() {
        let op = try! In(value: .array([["foo": "bar"]]), params: nil)
        let rhs: Any = ["foo": "bar"]

        XCTAssertTrue(op.match(rhs))
    }

    func testDictionaryArrayNotMatch() {
        let op = try! In(value: .array([["foo": "bar"]]), params: nil)
        let rhs: Any = ["foo": 123]

        XCTAssertFalse(op.match(rhs))
    }

    func testArrayOfArraysMatch() {
        let op = try! In(value: .array([[1, 2, 3]]), params: nil)
        let rhs: Any = [1, 2, 3]

        XCTAssertTrue(op.match(rhs))
    }

    func testArrayOfArraysNotMatch() {
        let op = try! In(value: .array([[1, 2, 3]]), params: nil)
        let rhs: Any = [1, 2, 3, 4]

        XCTAssertFalse(op.match(rhs))
    }

    func testStringsMatch() {
        let op = try! In(value: .string("xxxx-test-xxxx"), params: nil)
        let rhs: Any = "test"

        XCTAssertTrue(op.match(rhs))
    }

    func testStringsNotMatch() {
        let op = try! In(value: .string("xxxx-test-xxxx"), params: nil)
        let rhs: Any = "foo"

        XCTAssertFalse(op.match(rhs))
    }

    func testInvalidType() {
        XCTAssertThrowsError(try In(value: .number(123123), params: nil))
    }
}
