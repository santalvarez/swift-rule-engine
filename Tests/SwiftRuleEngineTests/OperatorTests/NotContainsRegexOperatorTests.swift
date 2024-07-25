//
//  NotContainsRegexOperatorTests.swift
//  SwiftRuleEngineTests
//
//  Created by Santiago Alvarez on 04/04/2023.
//

import XCTest
@testable import SwiftRuleEngine

final class NotContainsRegexOperatorTests: XCTestCase {

    func testStringArrayMatch() {
        let op = try! NotContainsRegex(value: .string("^/Users/.*/Desktop/hello.txt$"), params: nil)
        let rhs: Any = ["/Users/messi/Library/hello.txt"]

        XCTAssertTrue(op.match(rhs))
    }

    func testStringArrayMatch2() {
        let op = try! NotContainsRegex(value: .string("^/Users/.*/Desktop/hello.txt$"), params: nil)
        let rhs: Any = ["/Users/messi/Documents/hello.txt", "/Users/messi/Library/hello.txt"]

        XCTAssertTrue(op.match(rhs))
    }

    func testStringArrayNotMatch() {
        let op = try! NotContainsRegex(value: .string("^/Users/.*/Desktop/hello.txt$"), params: nil)
        let rhs: Any = ["/Users/messi/Desktop/hello.txt"]

        XCTAssertFalse(op.match(rhs))
    }

    func testStringArrayNotMatch2() {
        let op = try! NotContainsRegex(value: .string("^/Users/.*/Desktop/hello.txt$"), params: nil)
        let rhs: Any = ["/Users/messi/Documents/hello.txt", "/Users/messi/Desktop/hello.txt"]

        XCTAssertFalse(op.match(rhs))
    }

}
