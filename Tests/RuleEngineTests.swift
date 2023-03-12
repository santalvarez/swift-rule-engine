//
//  SwiftRuleEngineTests.swift
//  SwiftRuleEngineTests
//
//  Created by Santiago Alvarez on 22/12/2022.
//

import XCTest
@testable import SwiftRuleEngine


class RuleEngineTests: XCTestCase {

    func testRuleEngine() throws {
        let rule: [String: Any] = [
            "name": "test-rule",
            "description": "Test rule",
            "conditions": [
                "all": [
                    [
                        "path": "$.player.first_name",
                        "value": "Lionel",
                        "operator": "equal"
                    ],
                    [
                        "path": "$.player.last_name",
                        "value": "Messi",
                        "operator": "equal"
                    ]
                ]
            ]
        ]

        let obj = [
            "player": [
                "first_name": "Lionel",
                "last_name": "Messi"
            ]
        ]

        let engine = try RuleEngine(rules: [rule])

        let result = try XCTUnwrap(engine.evaluate(obj))
        
        XCTAssertTrue(result.conditions.match)
    }

}
