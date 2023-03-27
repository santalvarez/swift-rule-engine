//
//  NotInSetOperatorTests.swift
//  SwiftRuleEngineTests
//
//  Created by Santiago Alvarez on 27/03/2023.
//

import XCTest
@testable import SwiftRuleEngine

final class NotInSetOperatorTests: XCTestCase {

    func testStringNotInSetMatch() {
        let lhs = AnyCodable(value: Set(["test"]), valueType: .set)
        let condition = SimpleCondition(op: .in_set, value: lhs)
        let rhs: Any = "foo"

        let op = NotInSet()

        XCTAssertTrue(op.match(condition, rhs))
    }

    func testStringNotInSetNotMatch() {
        let lhs = AnyCodable(value: Set(["test"]), valueType: .set)
        let condition = SimpleCondition(op: .in_set, value: lhs)
        let rhs: Any = "test"

        let op = NotInSet()

        XCTAssertFalse(op.match(condition, rhs))
    }

    func testIntNotInSetMatch() {
        let lhs = AnyCodable(value: Set([1, 2, 3]), valueType: .set)
        let condition = SimpleCondition(op: .in_set, value: lhs)
        let rhs: Any = 4

        let op = NotInSet()

        XCTAssertTrue(op.match(condition, rhs))
    }

    func testIntNotInSetNotMatch() {
        let lhs = AnyCodable(value: Set([1, 2, 3]), valueType: .set)
        let condition = SimpleCondition(op: .in_set, value: lhs)
        let rhs: Any = 2

        let op = NotInSet()

        XCTAssertFalse(op.match(condition, rhs))
    }

    func testDoubleNotInSetMatch() {
        let lhs = AnyCodable(value: Set([1.0, 2.0, 3.0]), valueType: .set)
        let condition = SimpleCondition(op: .in_set, value: lhs)
        let rhs: Any = 4.0

        let op = NotInSet()

        XCTAssertTrue(op.match(condition, rhs))
    }

    func testDoubleNotInSetNotMatch() {
        let lhs = AnyCodable(value: Set([1.0, 2.0, 3.0]), valueType: .set)
        let condition = SimpleCondition(op: .in_set, value: lhs)
        let rhs: Any = 2.0

        let op = NotInSet()

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
