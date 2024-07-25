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
        let op = try! Contains(value: .string("test"), params: nil)
        let rhs: Any = ["test"]

        XCTAssertTrue(op.match(rhs))
    }

    func testStringArrayNotMatch() {
        let op = try! Contains(value: .string("test"), params: nil)
        let rhs: Any = ["foo", "bar"]

        XCTAssertFalse(op.match(rhs))
    }

    func testIntArrayMatch() {
        let op = try! Contains(value: .number(2), params: nil)
        let rhs: Any = [1, 2, 3]

        XCTAssertTrue(op.match(rhs))
    }

    func testIntArrayNotMatch() {
        let op = try! Contains(value: .number(4), params: nil)
        let rhs: Any = [1, 2, 3]

        XCTAssertFalse(op.match(rhs))
    }

    func testDoubleArrayMatch() {
        let op = try! Contains(value: .number(2.2), params: nil)
        let rhs: Any = [1.1, 2.2, 3.3]

        XCTAssertTrue(op.match(rhs))
    }

    func testDoubleArrayNotMatch() {
        let op = try! Contains(value: .number(4.4), params: nil)
        let rhs: Any = [1.1, 2.2, 3.3]

        XCTAssertFalse(op.match(rhs))
    }

    func testDictionaryArrayMatch() {
        let op = try! Contains(value: .dictionary(["foo": "bar"]), params: nil)
        let rhs: Any = [["foo": "bar"]]

        XCTAssertTrue(op.match(rhs))
    }

    func testDictionaryArrayNotMatch() {
        let op = try! Contains(value: .dictionary(["foo": "bar"]), params: nil)
        let rhs: Any = [["foo": 123]]

        XCTAssertFalse(op.match(rhs))
    }

    func testArrayOfArraysMatch() {
        let op = try! Contains(value: .array([1, 2, 3]), params: nil)
        let rhs: Any = [[1, 2, 3]]

        XCTAssertTrue(op.match(rhs))
    }

    func testArrayOfArraysNotMatch() {
        let op = try! Contains(value: .array([1, 2, 3]), params: nil)
        let rhs: Any = [[1, 2, 3, 4]]

        XCTAssertFalse(op.match(rhs))
    }

    func testStringsMatch() {
        let op = try! Contains(value: .string("test"), params: nil)
        let rhs: Any = "xxxx-test-xxxx"

        XCTAssertTrue(op.match(rhs))
    }

    func testStringsNotMatch() {
        let op = try! Contains(value: .string("foo"), params: nil)
        let rhs: Any = "xxxx-test-xxxx"

        XCTAssertFalse(op.match(rhs))
    }

    func testInvalidType() {
        let op = try! Contains(value: .number(123123), params: nil)
        let rhs: Any = 1233

        XCTAssertFalse(op.match(rhs))
    }

}
