//
//  JSONPathTests.swift
//
//
//  Created by Santiago Alvarez on 28/12/2023.
//

import XCTest
@testable import SwiftRuleEngine

final class JSONPathTests: XCTestCase {

    func testValidJSONPath() throws {
        XCTAssertNoThrow(try JSONPath("$"))
        XCTAssertNoThrow(try JSONPath("$.key"))
        XCTAssertNoThrow(try JSONPath("$.key.key"))
        XCTAssertNoThrow(try JSONPath("$.key[0]"))
        XCTAssertNoThrow(try JSONPath("$.key[0].key"))
        XCTAssertNoThrow(try JSONPath("$.key[0].key[1]"))
        XCTAssertNoThrow(try JSONPath("$.key[0].key[1].key"))
    }

    func testInvalidJSONPath() throws {
        XCTAssertThrowsError(try JSONPath(""))
        XCTAssertThrowsError(try JSONPath("$."))
        XCTAssertThrowsError(try JSONPath("$[0]"))
        XCTAssertThrowsError(try JSONPath("$[0].key"))
        XCTAssertThrowsError(try JSONPath("$.key[0"))
        XCTAssertThrowsError(try JSONPath("$.key[0]."))
        XCTAssertThrowsError(try JSONPath("$.key[0].key["))
        XCTAssertThrowsError(try JSONPath("$.key[0].key[1"))
        XCTAssertThrowsError(try JSONPath("$.key[0].key[1]."))
        XCTAssertThrowsError(try JSONPath("$key"))
        XCTAssertThrowsError(try JSONPath("$.key."))
        XCTAssertThrowsError(try JSONPath("$.key.."))
        XCTAssertThrowsError(try JSONPath("$.key.[0]"))
        XCTAssertThrowsError(try JSONPath("$.key.0]"))
        XCTAssertThrowsError(try JSONPath("$.key.a]"))
        XCTAssertThrowsError(try JSONPath("$key.key"))
        XCTAssertThrowsError(try JSONPath("$key[0]"))
        XCTAssertThrowsError(try JSONPath("asdf"))
        XCTAssertThrowsError(try JSONPath("asdf.asdf"))
        XCTAssertThrowsError(try JSONPath("$.key[a]"))
        XCTAssertThrowsError(try JSONPath("$.key[0].key[a]"))
        XCTAssertThrowsError(try JSONPath("$.key[0a]"))
        XCTAssertThrowsError(try JSONPath("$.key.*"))
        XCTAssertThrowsError(try JSONPath("$.key[-1]"))
    }

}
