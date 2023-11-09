//
//  SwiftRuleEngineTests.swift
//  SwiftRuleEngineTests
//
//  Created by Santiago Alvarez on 22/12/2022.
//

import XCTest
@testable import SwiftRuleEngine


class RuleEngineTests: XCTestCase {

    func testAllDoubleEqualCondition() throws {
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

    func testAllInCondition() throws {
        let rule: [String: Any] = [
            "name": "test-rule",
            "description": "Test rule",
            "conditions": [
                "all": [
                    [
                        "path": "$.player.first_name",
                        "value": ["Marcos", "Tomas", "Lionel", "Tony"],
                        "operator": "in"
                    ] as [String : Any]
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


    func testNestedAnyCondition() throws {
        let rule: [String: Any] = [
            "name": "test-rule",
            "description": "Test rule",
            "conditions": [
                "all": [
                    [
                        "path": "$.player.first_name",
                        "value": ["Marcos", "Tomas", "Lionel", "Tony"],
                        "operator": "in"
                    ] as [String : Any],
                    [
                        "any": [
                            [
                                "path": "$.player.last_name",
                                "value": "Ronaldo",
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

    func testNestedAllCondition() throws {
        let rule: [String: Any] = [
            "name": "test-rule",
            "description": "Test rule",
            "conditions": [
                "all": [
                    [
                        "path": "$.player.first_name",
                        "value": ["Marcos", "Tomas", "Lionel", "Tony"],
                        "operator": "in"
                    ] as [String : Any],
                    [
                        "all": [
                            [
                                "path": "$.player.age",
                                "value": 34,
                                "operator": "equal"
                            ] as [String : Any],
                            [
                                "path": "$.player.last_name",
                                "value": "Messi",
                                "operator": "equal"
                            ]
                        ]
                    ]
                ]
            ]
        ]

        let obj = [
            "player": [
                "first_name": "Lionel",
                "last_name": "Messi",
                "age": 34
            ] as [String : Any]
        ]

        let engine = try RuleEngine(rules: [rule])

        let result = try XCTUnwrap(engine.evaluate(obj))

        XCTAssertTrue(result.conditions.match)
    }


    func testNestedAllConditionWithAny() throws {
        let rule: [String: Any] = [
            "name": "test-rule",
            "description": "Test rule",
            "conditions": [
                "all": [
                    [
                        "path": "$.player.first_name",
                        "value": ["Marcos", "Tomas", "Lionel", "Tony"],
                        "operator": "in"
                    ] as [String : Any],
                    [
                        "all": [
                            [
                                "path": "$.player.age",
                                "value": 34,
                                "operator": "greater_than_inclusive"
                            ] as [String : Any],
                            [
                                "any": [
                                    [
                                        "path": "$.player.last_name",
                                        "value": "Ronaldo",
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
                    ]
                ]
            ]
        ]

        let obj = [
            "player": [
                "first_name": "Lionel",
                "last_name": "Messi",
                "age": 34
            ] as [String : Any]
        ]

        let engine = try RuleEngine(rules: [rule])

        let result = try XCTUnwrap(engine.evaluate(obj))

        XCTAssertTrue(result.conditions.match)
    }

    func testLoadStringRules() throws {
        let rule = """
            {
                "name": "test-rule",
                "description": "Test rule",
                "conditions": {
                    "all": [
                        {
                            "path": "$.player.first_name",
                            "value": ["Marcos", "Tomas", "Lionel", "Tony"],
                            "operator": "in"
                        }
                    ]
                }
            }
        """

        XCTAssertNoThrow(try RuleEngine(rules: [rule]))
    }

    func testAllConditionWithStringRule() throws {
        let rule = """
            {
                "name": "test-rule",
                "description": "Test rule",
                "conditions": {
                    "all": [
                        {
                            "path": "$.player.first_name",
                            "value": ["Marcos", "Tomas", "Lionel", "Tony"],
                            "operator": "in"
                        },
                        {
                            "path": "$.player.age",
                            "value": 30,
                            "operator": "greater_than"
                        },
                        {
                            "path": "$.player.age",
                            "value": 40,
                            "operator": "less_than"
                        }
                    ]
                }
            }
        """

        let obj: [String: Any] = [
            "player": [
                "first_name": "Lionel",
                "last_name": "Messi",
                "age": 34
            ] as [String : Any]
        ]

        let engine = try! RuleEngine(rules: [rule])

        let result = engine.evaluate(obj)

        XCTAssertTrue(result!.conditions.match)
    }


    func testNullMatch() throws {
        let rule = """
            {
                "name": "test-rule",
                "description": "Test rule",
                "conditions": {
                    "all": [
                        {
                            "path": "$.player.last_name",
                            "operator": "equal",
                            "value": null
                        }
                    ]
                }
            }
        """

        let obj = [
            "player": [
                "first_name": "Lionel",
                "clubs": ["boca", "madrid", "inter", "bayern"],
                "last_name": nil,
                "age": 34
            ] as [String : Any?]
        ]

        let engine = try! RuleEngine(rules: [rule])

        let result = engine.evaluate(obj)

        XCTAssertNotNil(result)
    }
}
