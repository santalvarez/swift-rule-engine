//
//  EndsWithOperatorTests.swift
//
//
//  Created by Santiago Alvarez on 21/12/2023.
//

import XCTest
@testable import SwiftRuleEngine

final class EndsWithOperatorTests: XCTestCase {

    func testMatch() {
        let op = try! EndsWith(value: .string("world"), params: nil)

        XCTAssertTrue(op.match("hello_world"))
    }

    func testNoMatch() {
        let op = try! EndsWith(value: .string("world"), params: nil)

        XCTAssertFalse(op.match("hello_world!"))
    }

    func testNoMatchTypeMismatch() {
        let op = try! EndsWith(value: .string("world"), params: nil)

        XCTAssertFalse(op.match(123))
    }
}
