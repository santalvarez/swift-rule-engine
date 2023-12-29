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
        let op = try! NotRegex(value: .string("^((25[0-5]|(2[0-4]|1[0-9]|[1-9]|)[0-9])(.(?!$)|$)){4}$"), params: nil)
        let rhs: Any = "192.168.0.1"

        XCTAssertFalse(op.match(rhs))
    }

    func testMatchInvalidDate() {
        let op = try! NotRegex(value: .string("^\\d{4}-\\d{2}-\\d{2}$"), params: nil)
        let rhs: Any = "03/03/2023"

        XCTAssertTrue(op.match(rhs))
    }

    func testMatchValidURL() {
        let op = try! NotRegex(value: .string("^https?://([\\w-]+\\.)+[\\w-]+(/[\\w-./?%&=]*)?$"), params: nil)
        let rhs: Any = "http://www.example.com/index.html"

        XCTAssertFalse(op.match(rhs))
    }

    func testMatchInvalidURL() {
        let op = try! NotRegex(value: .string("^https?://([\\w-]+\\.)+[\\w-]+(/[\\w-./?%&=]*)?$"), params: nil)
        let rhs: Any = "invalid-url"

        XCTAssertTrue(op.match(rhs))
    }

    func testMatchValidDate() {
        let op = try! NotRegex(value: .string("^\\d{4}-\\d{2}-\\d{2}$"), params: nil)
        let rhs: Any = "2023-03-03"

        XCTAssertFalse(op.match(rhs))
    }

    func testMatchValidEmailAddress() {
        let op = try! NotRegex(value: .string("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$"), params: nil)
        let rhs: Any = "test@example.com"

        XCTAssertFalse(op.match(rhs))
    }

    func testMatchInvalidEmailAddress() {
        let op = try! NotRegex(value: .string("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$"), params: nil)
        let rhs: Any = "invalid-email-address"

        XCTAssertTrue(op.match(rhs))
    }

    func testMatchValidUSPhoneNumber() {
        let op = try! NotRegex(value: .string("^\\(\\d{3}\\) \\d{3}-\\d{4}$"), params: nil)
        let rhs: Any = "(555) 555-5555"

        XCTAssertFalse(op.match(rhs))
    }

    func testMatchInvalidUSPhoneNumber() {
        let op = try! NotRegex(value: .string("^\\(\\d{3}\\) \\d{3}-\\d{4}$"), params: nil)
        let rhs: Any = "555-555-5555"

        XCTAssertTrue(op.match(rhs))
    }

    func testMatchValidCreditCardNumber() {
        let op = try! NotRegex(value: .string("^(\\d{4}[- ]?){3}\\d{4}|\\d{16}$"), params: nil)
        let rhs: Any = "4111-1111-1111-1111"

        XCTAssertFalse(op.match(rhs))
    }

    func testMatchInvalidCreditCardNumber() {
        let op = try! NotRegex(value: .string("^(\\d{4}[- ]?){3}\\d{4}|\\d{16}$"), params: nil)
        let rhs: Any = "invalid-credit-card-number"

        XCTAssertTrue(op.match(rhs))
    }

    func testMatchValidPassword() {
        let op = try! NotRegex(value: .string("^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"), params: nil)
        let rhs: Any = "Password123"

        XCTAssertFalse(op.match(rhs))
    }

    func testMatchInvalidPassword() {
        let op = try! NotRegex(value: .string("^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"), params: nil)
        let rhs: Any = "password"

        XCTAssertTrue(op.match(rhs))
    }
}
