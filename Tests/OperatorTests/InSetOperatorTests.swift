//
//  InSet.swift
//  SwiftRuleEngineTests
//
//  Created by Santiago Alvarez on 11/03/2023.
//

import XCTest
@testable import SwiftRuleEngine


//class InSetOperatorTests: XCTestCase {
//    func testStringInSetMatch() {
//        let op = try! InSet(value: AnyCodable(value: Set(["test"]), valueType: .set), params: nil)
//        let rhs: Any = "test"
//
//        XCTAssertTrue(op.match(rhs))
//    }
//
//    func testStringInSetNotMatch() {
//        let op = try! InSet(value: AnyCodable(value: Set(["foo", "bar"]), valueType: .set), params: nil)
//        let rhs: Any = "test"
//
//        XCTAssertFalse(op.match(rhs))
//    }
//
//    func testIntInSetMatch() {
//        let op = try! InSet(value: AnyCodable(value: Set([1, 2, 3]), valueType: .set), params: nil)
//        let rhs: Any = 2
//
//        XCTAssertTrue(op.match(rhs))
//    }
//
//    func testIntInSetNotMatch() {
//        let op = try! InSet(value: AnyCodable(value: Set([1, 2, 3]), valueType: .set), params: nil)
//        let rhs: Any = 4
//
//        XCTAssertFalse(op.match(rhs))
//    }
//
//    func testDoubleInSetMatch() {
//        let op = try! InSet(value: AnyCodable(value: Set([1.1, 2.2, 3.3]), valueType: .set), params: nil)
//        let rhs: Any = 2.2
//
//        XCTAssertTrue(op.match(rhs))
//    }
//
//    func testDoubleInSetNotMatch() {
//        let op = try! InSet(value: AnyCodable(value: Set([1.1, 2.2, 3.3]), valueType: .set), params: nil)
//        let rhs: Any = 4.4
//
//        XCTAssertFalse(op.match(rhs))
//    }
//
//    func testInvalidType() {
//        let op = try! InSet(value: AnyCodable(value: 123123, valueType: .set), params: nil)
//        let rhs: Any = "test"
//
//        XCTAssertFalse(op.match(rhs))
//    }
//}
