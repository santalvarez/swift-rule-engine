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
                "any": [
                    [
                        "path": "$.person.name",
                        "value": "Santiago",
                        "operator": "equal"
                    ]
                ]
            ]
        ]
        
        let obj = [
            "person": [
                "name": "Santiago"
            ]
        ]
        
        let engine = try RuleEngine(rules: [rule])

        let r = engine.evaluate(obj)
        let result = try XCTUnwrap(r)
        
        XCTAssertTrue(result.conditions.match)
    }

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
