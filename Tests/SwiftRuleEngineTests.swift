//
//  SwiftRuleEngineTests.swift
//  SwiftRuleEngineTests
//
//  Created by Santiago Alvarez on 16/12/2022.
//

import XCTest
@testable import SwiftRuleEngine

class SwiftRuleEngineTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }


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

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
