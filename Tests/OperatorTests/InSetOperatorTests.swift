//
//  InSet.swift
//  SwiftRuleEngineTests
//
//  Created by Santiago Alvarez on 11/03/2023.
//

import XCTest
@testable import SwiftRuleEngine


class InSetOperatorTests: XCTestCase {
    func testStringSetMatch() {
        let lhs = AnyCodable(value: Set(["test"]), valueType: .set)
        let condition = SimpleCondition(op: .in_set, value: lhs)
        let rhs: Any = "test"

        let op = InSet()

        XCTAssertTrue(op.match(condition, rhs))
    }

    func testStringSetNotMatch() {
        let lhs = AnyCodable(value: Set(["foo", "bar"]), valueType: .set)
        let condition = SimpleCondition(op: .in_set, value: lhs)
        let rhs: Any = "test"

        let op = InSet()

        XCTAssertFalse(op.match(condition, rhs))
    }

    func testIntSetMatch() {
        let lhs = AnyCodable(value: Set([1, 2, 3]), valueType: .set)
        let condition = SimpleCondition(op: .in_set, value: lhs)
        let rhs: Any = 2

        let op = InSet()

        XCTAssertTrue(op.match(condition, rhs))
    }

    func testIntSetNotMatch() {
        let lhs = AnyCodable(value: Set([1, 2, 3]), valueType: .set)
        let condition = SimpleCondition(op: .in_set, value: lhs)
        let rhs: Any = 4

        let op = InSet()

        XCTAssertFalse(op.match(condition, rhs))
    }

    func testDoubleSetMatch() {
        let lhs = AnyCodable(value: Set([1.1, 2.2, 3.3]), valueType: .set)
        let condition = SimpleCondition(op: .in_set, value: lhs)
        let rhs: Any = 2.2

        let op = InSet()

        XCTAssertTrue(op.match(condition, rhs))
    }

    func testDoubleSetNotMatch() {
        let lhs = AnyCodable(value: Set([1.1, 2.2, 3.3]), valueType: .set)
        let condition = SimpleCondition(op: .in_set, value: lhs)
        let rhs: Any = 4.4

        let op = InSet()

        XCTAssertFalse(op.match(condition, rhs))
    }

    func testInvalidType() {
        let lhs = AnyCodable(value: 123123, valueType: .set)
        let condition = SimpleCondition(op: .in_set, value: lhs)
        let rhs: Any = "test"

        let op = InSet()

        XCTAssertFalse(op.match(condition, rhs))
    }
}
