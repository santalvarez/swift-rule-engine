//
//  NotEndsWithOperatorTests.swift
//  
//
//  Created by Santiago Alvarez on 21/12/2023.
//

import XCTest
@testable import SwiftRuleEngine

final class NotEndsWithOperatorTests: XCTestCase {

    func testMatch() {
        let op = try! NotEndsWith(value: .init(value: "world", valueType: .string), params: nil)

        XCTAssertTrue(op.match("hello_world!"))
    }

    func testNoMatch() {
        let op = try! NotEndsWith(value: .init(value: "world", valueType: .string), params: nil)

        XCTAssertFalse(op.match("hello_world"))
    }

    func testNoMatchTypeMismatch() {
        let op = try! NotEndsWith(value: .init(value: "world", valueType: .string), params: nil)

        XCTAssertFalse(op.match(123))
    }
}
