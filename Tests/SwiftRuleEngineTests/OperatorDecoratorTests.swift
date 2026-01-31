//
//  OperatorDecoratorTests.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 28/01/2026.
//

import XCTest
@testable import SwiftRuleEngine


class OperatorDecoratorTests: XCTestCase {

    // MARK: - everyFact Decorator Tests

    func testEveryFactGreaterThanAllPass() throws {
        let rule: [String: Any] = [
            "name": "test-rule",
            "conditions": [
                "all": [
                    [
                        "path": "$.scores",
                        "value": 50,
                        "operator": "everyFact:greaterThan"
                    ] as [String: Any]
                ]
            ]
        ]

        let obj: [String: Any] = [
            "scores": [60, 70, 80, 90]
        ]

        let engine = try RuleEngine(rules: [rule])
        let result = engine.evaluate(obj)

        XCTAssertNotNil(result)
    }

    func testEveryFactGreaterThanSomeFail() throws {
        let rule: [String: Any] = [
            "name": "test-rule",
            "conditions": [
                "all": [
                    [
                        "path": "$.scores",
                        "value": 50,
                        "operator": "everyFact:greaterThan"
                    ] as [String: Any]
                ]
            ]
        ]

        let obj: [String: Any] = [
            "scores": [60, 40, 80, 90]  // 40 is not > 50
        ]

        let engine = try RuleEngine(rules: [rule])
        let result = engine.evaluate(obj)

        XCTAssertNil(result)
    }

    func testEveryFactWithNonArrayFails() throws {
        let rule: [String: Any] = [
            "name": "test-rule",
            "conditions": [
                "all": [
                    [
                        "path": "$.score",
                        "value": 50,
                        "operator": "everyFact:greaterThan"
                    ] as [String: Any]
                ]
            ]
        ]

        let obj: [String: Any] = [
            "score": 60  // Not an array
        ]

        let engine = try RuleEngine(rules: [rule])
        let result = engine.evaluate(obj)

        XCTAssertNil(result)  // Should fail because fact is not an array
    }

    func testEveryFactWithEmptyArray() throws {
        let rule: [String: Any] = [
            "name": "test-rule",
            "conditions": [
                "all": [
                    [
                        "path": "$.scores",
                        "value": 50,
                        "operator": "everyFact:greaterThan"
                    ] as [String: Any]
                ]
            ]
        ]

        let obj: [String: Any] = [
            "scores": [] as [Int]
        ]

        let engine = try RuleEngine(rules: [rule])
        let result = engine.evaluate(obj)

        // Empty array with allSatisfy returns true (vacuous truth)
        XCTAssertNotNil(result)
    }

    // MARK: - someFact Decorator Tests

    func testSomeFactGreaterThanOnePass() throws {
        let rule: [String: Any] = [
            "name": "test-rule",
            "conditions": [
                "all": [
                    [
                        "path": "$.scores",
                        "value": 90,
                        "operator": "someFact:greaterThan"
                    ] as [String: Any]
                ]
            ]
        ]

        let obj: [String: Any] = [
            "scores": [60, 70, 95, 80]  // 95 > 90
        ]

        let engine = try RuleEngine(rules: [rule])
        let result = engine.evaluate(obj)

        XCTAssertNotNil(result)
    }

    func testSomeFactGreaterThanNonePass() throws {
        let rule: [String: Any] = [
            "name": "test-rule",
            "conditions": [
                "all": [
                    [
                        "path": "$.scores",
                        "value": 90,
                        "operator": "someFact:greaterThan"
                    ] as [String: Any]
                ]
            ]
        ]

        let obj: [String: Any] = [
            "scores": [60, 70, 80, 85]  // None > 90
        ]

        let engine = try RuleEngine(rules: [rule])
        let result = engine.evaluate(obj)

        XCTAssertNil(result)
    }

    func testSomeFactWithNonArrayFails() throws {
        let rule: [String: Any] = [
            "name": "test-rule",
            "conditions": [
                "all": [
                    [
                        "path": "$.score",
                        "value": 50,
                        "operator": "someFact:greaterThan"
                    ] as [String: Any]
                ]
            ]
        ]

        let obj: [String: Any] = [
            "score": 60  // Not an array
        ]

        let engine = try RuleEngine(rules: [rule])
        let result = engine.evaluate(obj)

        XCTAssertNil(result)
    }

    func testSomeFactEqualWithStrings() throws {
        let rule: [String: Any] = [
            "name": "test-rule",
            "conditions": [
                "all": [
                    [
                        "path": "$.tags",
                        "value": "premium",
                        "operator": "someFact:equal"
                    ] as [String: Any]
                ]
            ]
        ]

        let obj: [String: Any] = [
            "tags": ["basic", "premium", "trial"]
        ]

        let engine = try RuleEngine(rules: [rule])
        let result = engine.evaluate(obj)

        XCTAssertNotNil(result)
    }

    // MARK: - everyValue Decorator Tests

    func testEveryValueLessThanAllPass() throws {
        let rule: [String: Any] = [
            "name": "test-rule",
            "conditions": [
                "all": [
                    [
                        "path": "$.age",
                        "value": [30, 40, 50],
                        "operator": "everyValue:lessThan"
                    ] as [String: Any]
                ]
            ]
        ]

        let obj: [String: Any] = [
            "age": 25  // 25 < 30, 25 < 40, 25 < 50
        ]

        let engine = try RuleEngine(rules: [rule])
        let result = engine.evaluate(obj)

        XCTAssertNotNil(result)
    }

    func testEveryValueLessThanSomeFail() throws {
        let rule: [String: Any] = [
            "name": "test-rule",
            "conditions": [
                "all": [
                    [
                        "path": "$.age",
                        "value": [30, 40, 50],
                        "operator": "everyValue:lessThan"
                    ] as [String: Any]
                ]
            ]
        ]

        let obj: [String: Any] = [
            "age": 35  // 35 < 40, 35 < 50, but NOT 35 < 30
        ]

        let engine = try RuleEngine(rules: [rule])
        let result = engine.evaluate(obj)

        XCTAssertNil(result)
    }

    func testEveryValueWithNonArrayValueFallback() throws {
        // When value is not an array, everyValue should just use the original operator
        let rule: [String: Any] = [
            "name": "test-rule",
            "conditions": [
                "all": [
                    [
                        "path": "$.age",
                        "value": 30,
                        "operator": "everyValue:lessThan"
                    ] as [String: Any]
                ]
            ]
        ]

        let obj: [String: Any] = [
            "age": 25
        ]

        let engine = try RuleEngine(rules: [rule])
        let result = engine.evaluate(obj)

        XCTAssertNotNil(result)
    }

    // MARK: - someValue Decorator Tests

    func testSomeValueLessThanOnePass() throws {
        let rule: [String: Any] = [
            "name": "test-rule",
            "conditions": [
                "all": [
                    [
                        "path": "$.age",
                        "value": [18, 21, 65],
                        "operator": "someValue:lessThan"
                    ] as [String: Any]
                ]
            ]
        ]

        let obj: [String: Any] = [
            "age": 20  // 20 < 21, 20 < 65 (passes for at least one)
        ]

        let engine = try RuleEngine(rules: [rule])
        let result = engine.evaluate(obj)

        XCTAssertNotNil(result)
    }

    func testSomeValueLessThanNonePass() throws {
        let rule: [String: Any] = [
            "name": "test-rule",
            "conditions": [
                "all": [
                    [
                        "path": "$.age",
                        "value": [18, 21, 25],
                        "operator": "someValue:lessThan"
                    ] as [String: Any]
                ]
            ]
        ]

        let obj: [String: Any] = [
            "age": 30  // 30 is not < any of [18, 21, 25]
        ]

        let engine = try RuleEngine(rules: [rule])
        let result = engine.evaluate(obj)

        XCTAssertNil(result)
    }

    func testSomeValueEqualWithStrings() throws {
        let rule: [String: Any] = [
            "name": "test-rule",
            "conditions": [
                "all": [
                    [
                        "path": "$.status",
                        "value": ["active", "pending", "approved"],
                        "operator": "someValue:equal"
                    ] as [String: Any]
                ]
            ]
        ]

        let obj: [String: Any] = [
            "status": "pending"
        ]

        let engine = try RuleEngine(rules: [rule])
        let result = engine.evaluate(obj)

        XCTAssertNotNil(result)
    }

    // MARK: - Decorator Composition Tests

    func testEveryFactEveryValueLessThan() throws {
        // Every element in fact array must be less than every element in value array
        let rule: [String: Any] = [
            "name": "test-rule",
            "conditions": [
                "all": [
                    [
                        "path": "$.scores",
                        "value": [100, 200, 300],
                        "operator": "everyFact:everyValue:lessThan"
                    ] as [String: Any]
                ]
            ]
        ]

        let obj: [String: Any] = [
            "scores": [10, 20, 30]  // All are < 100, < 200, < 300
        ]

        let engine = try RuleEngine(rules: [rule])
        let result = engine.evaluate(obj)

        XCTAssertNotNil(result)
    }

    func testEveryFactEveryValueLessThanFail() throws {
        let rule: [String: Any] = [
            "name": "test-rule",
            "conditions": [
                "all": [
                    [
                        "path": "$.scores",
                        "value": [100, 200, 300],
                        "operator": "everyFact:everyValue:lessThan"
                    ] as [String: Any]
                ]
            ]
        ]

        let obj: [String: Any] = [
            "scores": [10, 150, 30]  // 150 is not < 100
        ]

        let engine = try RuleEngine(rules: [rule])
        let result = engine.evaluate(obj)

        XCTAssertNil(result)
    }

    func testEveryFactSomeValueEqual() throws {
        // Every element in fact array must equal at least one element in value array
        let rule: [String: Any] = [
            "name": "test-rule",
            "conditions": [
                "all": [
                    [
                        "path": "$.tags",
                        "value": ["a", "b", "c"],
                        "operator": "everyFact:someValue:equal"
                    ] as [String: Any]
                ]
            ]
        ]

        let obj: [String: Any] = [
            "tags": ["a", "c", "b"]  // All are in ["a", "b", "c"]
        ]

        let engine = try RuleEngine(rules: [rule])
        let result = engine.evaluate(obj)

        XCTAssertNotNil(result)
    }

    func testEveryFactSomeValueEqualFail() throws {
        let rule: [String: Any] = [
            "name": "test-rule",
            "conditions": [
                "all": [
                    [
                        "path": "$.tags",
                        "value": ["a", "b", "c"],
                        "operator": "everyFact:someValue:equal"
                    ] as [String: Any]
                ]
            ]
        ]

        let obj: [String: Any] = [
            "tags": ["a", "d", "b"]  // "d" is not in ["a", "b", "c"]
        ]

        let engine = try RuleEngine(rules: [rule])
        let result = engine.evaluate(obj)

        XCTAssertNil(result)
    }

    func testSomeFactSomeValueEqual() throws {
        // At least one element in fact array must equal at least one element in value array
        let rule: [String: Any] = [
            "name": "test-rule",
            "conditions": [
                "all": [
                    [
                        "path": "$.tags",
                        "value": ["premium", "vip"],
                        "operator": "someFact:someValue:equal"
                    ] as [String: Any]
                ]
            ]
        ]

        let obj: [String: Any] = [
            "tags": ["basic", "trial", "vip"]  // "vip" matches
        ]

        let engine = try RuleEngine(rules: [rule])
        let result = engine.evaluate(obj)

        XCTAssertNotNil(result)
    }

    func testSomeFactEveryValueGreaterThan() throws {
        // At least one element in fact array must be greater than every element in value array
        let rule: [String: Any] = [
            "name": "test-rule",
            "conditions": [
                "all": [
                    [
                        "path": "$.scores",
                        "value": [10, 20, 30],
                        "operator": "someFact:everyValue:greaterThan"
                    ] as [String: Any]
                ]
            ]
        ]

        let obj: [String: Any] = [
            "scores": [5, 15, 50]  // 50 > 10, 50 > 20, 50 > 30
        ]

        let engine = try RuleEngine(rules: [rule])
        let result = engine.evaluate(obj)

        XCTAssertNotNil(result)
    }

    // MARK: - Edge Cases

    func testDecoratorWithContainsOperator() throws {
        let rule: [String: Any] = [
            "name": "test-rule",
            "conditions": [
                "all": [
                    [
                        "path": "$.messages",
                        "value": "error",
                        "operator": "someFact:contains"
                    ] as [String: Any]
                ]
            ]
        ]

        let obj: [String: Any] = [
            "messages": ["success", "warning: check input", "error: failed"]
        ]

        let engine = try RuleEngine(rules: [rule])
        let result = engine.evaluate(obj)

        XCTAssertNotNil(result)
    }

    func testDecoratorWithRegexOperator() throws {
        let rule: [String: Any] = [
            "name": "test-rule",
            "conditions": [
                "all": [
                    [
                        "path": "$.emails",
                        "value": "^[a-z]+@example\\.com$",
                        "operator": "everyFact:regex"
                    ] as [String: Any]
                ]
            ]
        ]

        let obj: [String: Any] = [
            "emails": ["john@example.com", "jane@example.com"]
        ]

        let engine = try RuleEngine(rules: [rule])
        let result = engine.evaluate(obj)

        XCTAssertNotNil(result)
    }

    func testUnknownDecoratorThrowsError() throws {
        let rule: [String: Any] = [
            "name": "test-rule",
            "conditions": [
                "all": [
                    [
                        "path": "$.scores",
                        "value": 50,
                        "operator": "unknownDecorator:greaterThan"
                    ] as [String: Any]
                ]
            ]
        ]

        XCTAssertThrowsError(try RuleEngine(rules: [rule], strategy: .strict))
    }

    func testDecoratorNormalization() throws {
        // Test that decorator names are normalized (case-insensitive, ignore underscores/hyphens)
        let rule: [String: Any] = [
            "name": "test-rule",
            "conditions": [
                "all": [
                    [
                        "path": "$.scores",
                        "value": 50,
                        "operator": "every_fact:greater_than"
                    ] as [String: Any]
                ]
            ]
        ]

        let obj: [String: Any] = [
            "scores": [60, 70, 80]
        ]

        let engine = try RuleEngine(rules: [rule])
        let result = engine.evaluate(obj)

        XCTAssertNotNil(result)
    }

    func testOperatorWithoutDecorator() throws {
        // Ensure regular operators still work without decorators
        let rule: [String: Any] = [
            "name": "test-rule",
            "conditions": [
                "all": [
                    [
                        "path": "$.age",
                        "value": 18,
                        "operator": "greaterThan"
                    ] as [String: Any]
                ]
            ]
        ]

        let obj: [String: Any] = [
            "age": 25
        ]

        let engine = try RuleEngine(rules: [rule])
        let result = engine.evaluate(obj)

        XCTAssertNotNil(result)
    }

    func testSomeFactInDecorator() throws {
        let rule: [String: Any] = [
            "name": "test-rule",
            "conditions": [
                "all": [
                    [
                        "path": "$.tags",
                        "operator": "someFact:in",
                        "value": ["premium", "verified", "active"]
                    ] as [String: Any]
                ]
            ]
        ]

        let fact: [String: Any] = [
            "tags": ["new", "active"]
        ]

        let engine = try RuleEngine(rules: [rule])
        let result = engine.evaluate(fact)
        XCTAssertNotNil(result)
    }
}
