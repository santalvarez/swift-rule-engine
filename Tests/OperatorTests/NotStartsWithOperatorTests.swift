//
//  NotStartsWithOperatorTests.swift
//  
//
//  Created by Santiago Alvarez on 21/12/2023.
//

import XCTest
@testable import SwiftRuleEngine

final class NotStartsWithOperatorTests: XCTestCase {

    func testMatch() {
        let op = try! NotStartsWith(value: .init(value: "hello", valueType: .string), params: nil)

        XCTAssertTrue(op.match("¡hello_world"))
    }

    func testNoMatch() {
        let op = try! NotStartsWith(value: .init(value: "hello", valueType: .string), params: nil)

        XCTAssertFalse(op.match("hello_world!"))
    }

    func testNoMatchTypeMismatch() {
        let op = try! NotStartsWith(value: .init(value: "hello", valueType: .string), params: nil)

        XCTAssertFalse(op.match(123))
    }
}
