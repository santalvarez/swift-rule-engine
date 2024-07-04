//
//  RuleEngineSubscriptableTests.swift
//
//
//  Created by Santiago Alvarez on 15/06/2024.
//

import Foundation



import XCTest
@testable import SwiftRuleEngine


class RuleEngineSubscriptableTests: XCTestCase {
    struct S: StringSubscriptable {
        let name: String

        static private let keys: [String: PartialKeyPath<Self>] = [
            "name": \.name
        ]

        subscript(key: String) -> Any? {
            guard let kp = Self.keys[key] else {
                return nil
            }
            return self[keyPath: kp]
        }
    }

    func testBasicRuleMatch() throws {
        let rule: [String: Any] = [
            "name": "test-rule",
            "conditions": [
                "all": [
                    [
                        "path": "$.name",
                        "value": "Lionel",
                        "operator": "equal"
                    ]
                ]
            ]
        ]

        let obj = S(name: "Lionel")

        let engine = try RuleEngine(rules: [rule])

        let result = try XCTUnwrap(engine.evaluate(obj))

        XCTAssertTrue(result.conditions.match)
    }

    func testBasicRuleNotMatch() throws {
        let rule: [String: Any] = [
            "name": "test-rule",
            "conditions": [
                "all": [
                    [
                        "path": "$.name",
                        "value": "Lionel",
                        "operator": "equal"
                    ]
                ]
            ]
        ]

        let obj = S(name: "Cristiano")

        let engine = try RuleEngine(rules: [rule])

        XCTAssertNil(engine.evaluate(obj))
    }
}
