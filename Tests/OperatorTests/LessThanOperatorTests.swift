//
//  OperatorTests.swift
//  SwiftRuleEngineTests
//
//  Created by Santiago Alvarez on 22/02/2023.
//

import XCTest
@testable import SwiftRuleEngine


class LessThanOperatorTests: XCTestCase {

    func testIntsMatch() {
        let op = try! LessThan(value: .number(100), params: nil)
        let rhs: Any = 99

        XCTAssertTrue(op.match(rhs))
    }

    func testIntsNotMatch() {
        let op = try! LessThan(value: .number(100), params: nil)
        let rhs: Any = 101

        XCTAssertFalse(op.match(rhs))
    }

    func testDoublesMatch() {
        let op = try! LessThan(value: .number(100.11), params: nil)
        let rhs: Any = 100.09

        XCTAssertTrue(op.match(rhs))
    }

    func testDoublesNotMatch() {
        let op = try! LessThan(value: .number(100.11), params: nil)
        let rhs: Any = 100.13

        XCTAssertFalse(op.match(rhs))
    }

    func testStringsMatch() {
        let op = try! LessThan(value: .string("test"), params: nil)
        let rhs: Any = "t"

        XCTAssertTrue(op.match(rhs))
    }

    func testStringsNotMatch() {
        let op = try! LessThan(value: .string("test"), params: nil)
        let rhs: Any = "test_test"

        XCTAssertFalse(op.match(rhs))
    }

    func testInvalidType() {
        let op = try! LessThan(value: .bool(true), params: nil)
        let rhs: Any = false

        XCTAssertFalse(op.match(rhs))
    }

}
