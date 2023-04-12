//
//  NotRegexOperatorTests.swift
//  SwiftRuleEngineTests
//
//  Created by Santiago Alvarez on 11/04/2023.
//

import XCTest
@testable import SwiftRuleEngine


final class NotRegexOperatorTests: XCTestCase {
    func testMatchIPAddress() {
        let lhs = AnyCodable(value: try! NSRegularExpression(pattern:"^((25[0-5]|(2[0-4]|1[0-9]|[1-9]|)[0-9])(.(?!$)|$)){4}$"), valueType: .regex)
        let condition = SimpleCondition(op: .not_regex, value: lhs)
        let rhs: Any = "192.168.0.1"

        let op = NotRegex()

        XCTAssertFalse(op.match(condition, rhs))
    }

    func testMatchInvalidDate() {
        let lhs = AnyCodable(value: try! NSRegularExpression(pattern:"^\\d{4}-\\d{2}-\\d{2}$"), valueType: .regex)
        let condition = SimpleCondition(op: .not_regex, value: lhs)
        let rhs: Any = "03/03/2023"

        let op = NotRegex()

        XCTAssertTrue(op.match(condition, rhs))
    }

    func testMatchValidURL() {
        let lhs = AnyCodable(value: try! NSRegularExpression(pattern:"^https?://([\\w-]+\\.)+[\\w-]+(/[\\w-./?%&=]*)?$"), valueType: .regex)
        let condition = SimpleCondition(op: .not_regex, value: lhs)
        let rhs: Any = "http://www.example.com/index.html"

        let op = NotRegex()

        XCTAssertFalse(op.match(condition, rhs))
    }

    func testMatchInvalidURL() {
        let lhs = AnyCodable(value: try! NSRegularExpression(pattern:"^https?://([\\w-]+\\.)+[\\w-]+(/[\\w-./?%&=]*)?$"), valueType: .regex)
        let condition = SimpleCondition(op: .not_regex, value: lhs)
        let rhs: Any = "invalid-url"

        let op = NotRegex()

        XCTAssertTrue(op.match(condition, rhs))
    }

    func testMatchValidDate() {
        let lhs = AnyCodable(value: try! NSRegularExpression(pattern:"^\\d{4}-\\d{2}-\\d{2}$"), valueType: .regex)
        let condition = SimpleCondition(op: .not_regex, value: lhs)
        let rhs: Any = "2023-03-03"

        let op = NotRegex()

        XCTAssertFalse(op.match(condition, rhs))
    }

    func testMatchValidEmailAddress() {
        let lhs = AnyCodable(value: try! NSRegularExpression(pattern:"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$"), valueType: .regex)
        let condition = SimpleCondition(op: .not_regex, value: lhs)
        let rhs: Any = "test@example.com"

        let op = NotRegex()

        XCTAssertFalse(op.match(condition, rhs))
    }

    func testMatchInvalidEmailAddress() {
        let lhs = AnyCodable(value: try! NSRegularExpression(pattern:"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$"), valueType: .regex)
        let condition = SimpleCondition(op: .not_regex, value: lhs)
        let rhs: Any = "invalid-email-address"

        let op = NotRegex()

        XCTAssertTrue(op.match(condition, rhs))
    }

    func testMatchValidUSPhoneNumber() {
        let lhs = AnyCodable(value: try! NSRegularExpression(pattern:"^\\(\\d{3}\\) \\d{3}-\\d{4}$"), valueType: .regex)
        let condition = SimpleCondition(op: .not_regex, value: lhs)
        let rhs: Any = "(555) 555-5555"

        let op = NotRegex()

        XCTAssertFalse(op.match(condition, rhs))
    }

    func testMatchInvalidUSPhoneNumber() {
        let lhs = AnyCodable(value: try! NSRegularExpression(pattern:"^\\(\\d{3}\\) \\d{3}-\\d{4}$"), valueType: .regex)
        let condition = SimpleCondition(op: .not_regex, value: lhs)
        let rhs: Any = "555-555-5555"

        let op = NotRegex()

        XCTAssertTrue(op.match(condition, rhs))
    }

    func testMatchValidCreditCardNumber() {
        let lhs = AnyCodable(value: try! NSRegularExpression(pattern:"^(\\d{4}[- ]?){3}\\d{4}|\\d{16}$"), valueType: .regex)
        let condition = SimpleCondition(op: .not_regex, value: lhs)
        let rhs: Any = "4111-1111-1111-1111"

        let op = NotRegex()

        XCTAssertFalse(op.match(condition, rhs))
    }

    func testMatchInvalidCreditCardNumber() {
        let lhs = AnyCodable(value: try! NSRegularExpression(pattern:"^(\\d{4}[- ]?){3}\\d{4}|\\d{16}$"), valueType: .regex)
        let condition = SimpleCondition(op: .not_regex, value: lhs)
        let rhs: Any = "invalid-credit-card-number"

        let op = NotRegex()

        XCTAssertTrue(op.match(condition, rhs))
    }

    func testMatchValidPassword() {
        let lhs = AnyCodable(value: try! NSRegularExpression(pattern:"^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"), valueType: .regex)
        let condition = SimpleCondition(op: .not_regex, value: lhs)
        let rhs: Any = "Password123"

        let op = NotRegex()

        XCTAssertFalse(op.match(condition, rhs))
    }

    func testMatchInvalidPassword() {
        let lhs = AnyCodable(value: try! NSRegularExpression(pattern:"^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"), valueType: .regex)
        let condition = SimpleCondition(op: .not_regex, value: lhs)
        let rhs: Any = "password"

        let op = NotRegex()

        XCTAssertTrue(op.match(condition, rhs))
    }
}
