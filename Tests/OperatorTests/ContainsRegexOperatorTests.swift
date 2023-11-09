//
//  ContainsRegexOperatorTests.swift
//  SwiftRuleEngineTests
//
//  Created by Santiago Alvarez on 04/04/2023.
//

import XCTest
@testable import SwiftRuleEngine


final class ContainsRegexOperatorTests: XCTestCase {

    func testStringArrayMatch() {
        let op = try! ContainsRegex(value: AnyCodable(value: "^/Users/.*/Desktop/hello.txt$", valueType: .string), params: nil)
        let rhs: Any = ["/Users/messi/Desktop/hello.txt"]

        XCTAssertTrue(op.match(rhs))
    }

    func testStringArrayMatch2() {
        let op = try! ContainsRegex(value: AnyCodable(value: "^/Users/.*/Desktop/hello.txt$", valueType: .string), params: nil)
        let rhs: Any = ["/Users/messi/Documents/hello.txt", "/Users/messi/Desktop/hello.txt"]

        XCTAssertTrue(op.match(rhs))
    }

    func testStringArrayNotMatch() {
        let op = try! ContainsRegex(value: AnyCodable(value: "^/Users/.*/Desktop/hello.txt$", valueType: .string), params: nil)
        let rhs: Any = ["/Users/messi/Library/hello.txt"]

        XCTAssertFalse(op.match(rhs))
    }

    func testStringArrayNotMatch2() {
        let op = try! ContainsRegex(value: AnyCodable(value: "^/Users/.*/Desktop/hello.txt$", valueType: .string), params: nil)
        let rhs: Any = ["/Users/messi/Documents/hello.txt", "/Users/messi/Library/hello.txt"]

        XCTAssertFalse(op.match(rhs))
    }

}
