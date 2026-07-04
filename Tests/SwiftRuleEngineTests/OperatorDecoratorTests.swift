//
//  OperatorDecoratorTests.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 28/01/2026.
//

import XCTest
@testable import SwiftRuleEngine


class OperatorDecoratorTests: XCTestCase {

    // MARK: - Helpers

    private typealias OperatorCase = (operatorName: String, value: Any, fact: Any)

    private func evaluate(_ operatorName: String, value: Any, fact: Any) throws -> Rule? {
        let rule: [String: Any] = [
            "name": "test-rule",
            "conditions": [
                "all": [
                    [
                        "path": "$.fact",
                        "value": value,
                        "operator": operatorName
                    ] as [String: Any]
                ]
            ]
        ]

        let engine = try RuleEngine(rules: [rule])
        return engine.evaluate(["fact": fact])
    }

    private func assertMatches(_ operatorName: String,
                               value: Any,
                               fact: Any,
                               file: StaticString = #filePath,
                               line: UInt = #line) throws {
        XCTAssertNotNil(try evaluate(operatorName, value: value, fact: fact),
                        "\(operatorName) should match",
                        file: file,
                        line: line)
    }

    private func assertDoesNotMatch(_ operatorName: String,
                                    value: Any,
                                    fact: Any,
                                    file: StaticString = #filePath,
                                    line: UInt = #line) throws {
        XCTAssertNil(try evaluate(operatorName, value: value, fact: fact),
                     "\(operatorName) should not match",
                     file: file,
                     line: line)
    }

    private func assertAllMatch(_ cases: [OperatorCase],
                                file: StaticString = #filePath,
                                line: UInt = #line) throws {
        for testCase in cases {
            try assertMatches(testCase.operatorName,
                              value: testCase.value,
                              fact: testCase.fact,
                              file: file,
                              line: line)
        }
    }

    // MARK: - everyFact x Operators

    func testEveryFactEqual() throws {
        try assertMatches("everyFact:equal", value: "x", fact: ["x", "x"])
    }

    func testEveryFactNotEqual() throws {
        try assertMatches("everyFact:notEqual", value: "x", fact: ["a", "b"])
    }

    func testEveryFactLessThan() throws {
        try assertMatches("everyFact:lessThan", value: 100, fact: [10, 20])
    }

    func testEveryFactLessThanInclusive() throws {
        try assertMatches("everyFact:lessThanInclusive", value: 50, fact: [50, 40])
    }

    func testEveryFactGreaterThan() throws {
        try assertMatches("everyFact:greaterThan", value: 50, fact: [60, 70])
    }

    func testEveryFactGreaterThanInclusive() throws {
        try assertMatches("everyFact:greaterThanInclusive", value: 50, fact: [50, 60])
    }

    func testEveryFactIn() throws {
        try assertMatches("everyFact:in", value: ["a", "b", "c"], fact: ["a", "b"])
    }

    func testEveryFactNotIn() throws {
        try assertMatches("everyFact:notIn", value: ["x", "y"], fact: ["a", "b"])
    }

    func testEveryFactContains() throws {
        try assertMatches("everyFact:contains", value: "err", fact: ["error", "superr"])
    }

    func testEveryFactNotContains() throws {
        try assertMatches("everyFact:notContains", value: "z", fact: ["abc", "def"])
    }

    func testEveryFactRegex() throws {
        try assertMatches("everyFact:regex", value: "^a", fact: ["apple", "ant"])
    }

    func testEveryFactNotRegex() throws {
        try assertMatches("everyFact:notRegex", value: "^z", fact: ["abc", "def"])
    }

    func testEveryFactContainsRegex() throws {
        try assertMatches("everyFact:containsRegex", value: "^a", fact: [["apple", "x"], ["ant"]])
    }

    func testEveryFactNotContainsRegex() throws {
        try assertMatches("everyFact:notContainsRegex", value: "^z", fact: [["apple"], ["ant"]])
    }

    func testEveryFactStartsWith() throws {
        try assertMatches("everyFact:startswith", value: "pre", fact: ["prefix", "present"])
    }

    func testEveryFactNotStartsWith() throws {
        try assertMatches("everyFact:notStartswith", value: "x", fact: ["abc", "def"])
    }

    func testEveryFactEndsWith() throws {
        try assertMatches("everyFact:endswith", value: "ing", fact: ["running", "jumping"])
    }

    func testEveryFactNotEndsWith() throws {
        try assertMatches("everyFact:notEndswith", value: "z", fact: ["abc", "def"])
    }

    // MARK: - someFact x Operators

    func testSomeFactEqual() throws {
        try assertMatches("someFact:equal", value: "premium", fact: ["basic", "premium", "trial"])
    }

    func testSomeFactNotEqual() throws {
        try assertMatches("someFact:notEqual", value: "x", fact: ["x", "y"])
    }

    func testSomeFactLessThan() throws {
        try assertMatches("someFact:lessThan", value: 50, fact: [60, 40])
    }

    func testSomeFactLessThanInclusive() throws {
        try assertMatches("someFact:lessThanInclusive", value: 50, fact: [60, 50])
    }

    func testSomeFactGreaterThan() throws {
        try assertMatches("someFact:greaterThan", value: 90, fact: [60, 95])
    }

    func testSomeFactGreaterThanInclusive() throws {
        try assertMatches("someFact:greaterThanInclusive", value: 90, fact: [50, 90])
    }

    func testSomeFactIn() throws {
        try assertMatches("someFact:in", value: ["premium", "verified", "active"], fact: ["new", "active"])
    }

    func testSomeFactNotIn() throws {
        try assertMatches("someFact:notIn", value: ["a", "b"], fact: ["a", "c"])
    }

    func testSomeFactContains() throws {
        try assertMatches("someFact:contains", value: "error", fact: ["success", "error: failed"])
    }

    func testSomeFactNotContains() throws {
        try assertMatches("someFact:notContains", value: "z", fact: ["zoo", "abc"])
    }

    func testSomeFactRegex() throws {
        try assertMatches("someFact:regex", value: "^a", fact: ["bbb", "axe"])
    }

    func testSomeFactNotRegex() throws {
        try assertMatches("someFact:notRegex", value: "^a", fact: ["axe", "bbb"])
    }

    func testSomeFactContainsRegex() throws {
        try assertMatches("someFact:containsRegex", value: "^a", fact: [["xyz"], ["apple"]])
    }

    func testSomeFactNotContainsRegex() throws {
        try assertMatches("someFact:notContainsRegex", value: "^a", fact: [["apple"], ["xyz"]])
    }

    func testSomeFactStartsWith() throws {
        try assertMatches("someFact:startswith", value: "pre", fact: ["xyz", "prefix"])
    }

    func testSomeFactNotStartsWith() throws {
        try assertMatches("someFact:notStartswith", value: "pre", fact: ["prefix", "xyz"])
    }

    func testSomeFactEndsWith() throws {
        try assertMatches("someFact:endswith", value: "ing", fact: ["abc", "running"])
    }

    func testSomeFactNotEndsWith() throws {
        try assertMatches("someFact:notEndswith", value: "ing", fact: ["running", "abc"])
    }

    // MARK: - everyValue x Operators

    func testEveryValueEqual() throws {
        try assertMatches("everyValue:equal", value: ["x", "x"], fact: "x")
    }

    func testEveryValueNotEqual() throws {
        try assertMatches("everyValue:notEqual", value: ["a", "b"], fact: "c")
    }

    func testEveryValueLessThan() throws {
        try assertMatches("everyValue:lessThan", value: [30, 40, 50], fact: 25)
    }

    func testEveryValueLessThanInclusive() throws {
        try assertMatches("everyValue:lessThanInclusive", value: [30, 40], fact: 30)
    }

    func testEveryValueGreaterThan() throws {
        try assertMatches("everyValue:greaterThan", value: [10, 20, 30], fact: 50)
    }

    func testEveryValueGreaterThanInclusive() throws {
        try assertMatches("everyValue:greaterThanInclusive", value: [10, 20], fact: 20)
    }

    func testEveryValueIn() throws {
        try assertMatches("everyValue:in", value: ["foobar", "barbaz"], fact: "bar")
    }

    func testEveryValueNotIn() throws {
        try assertMatches("everyValue:notIn", value: ["abc", "def"], fact: "xyz")
    }

    func testEveryValueContains() throws {
        try assertMatches("everyValue:contains", value: ["a", "b"], fact: "abc")
    }

    func testEveryValueNotContains() throws {
        try assertMatches("everyValue:notContains", value: ["x", "y"], fact: "abc")
    }

    func testEveryValueRegex() throws {
        try assertMatches("everyValue:regex", value: ["^a", "c$"], fact: "abc")
    }

    func testEveryValueNotRegex() throws {
        try assertMatches("everyValue:notRegex", value: ["^z", "^q"], fact: "abc")
    }

    func testEveryValueContainsRegex() throws {
        try assertMatches("everyValue:containsRegex", value: ["^a", "^ap"], fact: ["apple"])
    }

    func testEveryValueNotContainsRegex() throws {
        try assertMatches("everyValue:notContainsRegex", value: ["^z", "^q"], fact: ["apple"])
    }

    func testEveryValueStartsWith() throws {
        try assertMatches("everyValue:startswith", value: ["a", "ab"], fact: "abc")
    }

    func testEveryValueNotStartsWith() throws {
        try assertMatches("everyValue:notStartswith", value: ["x", "y"], fact: "abc")
    }

    func testEveryValueEndsWith() throws {
        try assertMatches("everyValue:endswith", value: ["c", "bc"], fact: "abc")
    }

    func testEveryValueNotEndsWith() throws {
        try assertMatches("everyValue:notEndswith", value: ["x", "y"], fact: "abc")
    }

    // MARK: - someValue x Operators

    func testSomeValueEqual() throws {
        try assertMatches("someValue:equal", value: ["active", "pending", "approved"], fact: "pending")
    }

    func testSomeValueNotEqual() throws {
        try assertMatches("someValue:notEqual", value: ["a", "b"], fact: "a")
    }

    func testSomeValueLessThan() throws {
        try assertMatches("someValue:lessThan", value: [18, 21, 65], fact: 20)
    }

    func testSomeValueLessThanInclusive() throws {
        try assertMatches("someValue:lessThanInclusive", value: [10, 20], fact: 20)
    }

    func testSomeValueGreaterThan() throws {
        try assertMatches("someValue:greaterThan", value: [10, 20, 30], fact: 25)
    }

    func testSomeValueGreaterThanInclusive() throws {
        try assertMatches("someValue:greaterThanInclusive", value: [10, 20, 30], fact: 20)
    }

    func testSomeValueIn() throws {
        try assertMatches("someValue:in", value: ["foobar", "x"], fact: "foo")
    }

    func testSomeValueNotIn() throws {
        try assertMatches("someValue:notIn", value: ["abc", "xyz"], fact: "q")
    }

    func testSomeValueContains() throws {
        try assertMatches("someValue:contains", value: ["q", "b"], fact: "abc")
    }

    func testSomeValueNotContains() throws {
        try assertMatches("someValue:notContains", value: ["q", "b"], fact: "abc")
    }

    func testSomeValueRegex() throws {
        try assertMatches("someValue:regex", value: ["^z", "^a"], fact: "abc")
    }

    func testSomeValueNotRegex() throws {
        try assertMatches("someValue:notRegex", value: ["^a", "^z"], fact: "abc")
    }

    func testSomeValueContainsRegex() throws {
        try assertMatches("someValue:containsRegex", value: ["^z", "^a"], fact: ["apple"])
    }

    func testSomeValueNotContainsRegex() throws {
        try assertMatches("someValue:notContainsRegex", value: ["^a", "^z"], fact: ["apple"])
    }

    func testSomeValueStartsWith() throws {
        try assertMatches("someValue:startswith", value: ["x", "ab"], fact: "abc")
    }

    func testSomeValueNotStartsWith() throws {
        try assertMatches("someValue:notStartswith", value: ["abc", "x"], fact: "abc")
    }

    func testSomeValueEndsWith() throws {
        try assertMatches("someValue:endswith", value: ["x", "bc"], fact: "abc")
    }

    func testSomeValueNotEndsWith() throws {
        try assertMatches("someValue:notEndswith", value: ["bc", "x"], fact: "abc")
    }

    // MARK: - Decorator Semantics

    func testEveryFactRequiresEveryFactToMatch() throws {
        try assertDoesNotMatch("everyFact:greaterThan", value: 50, fact: [60, 40, 80])
    }

    func testSomeFactRequiresAtLeastOneFactToMatch() throws {
        try assertDoesNotMatch("someFact:greaterThan", value: 90, fact: [60, 70, 80])
    }

    func testEveryValueRequiresEveryValueToMatch() throws {
        try assertDoesNotMatch("everyValue:lessThan", value: [30, 40, 50], fact: 35)
    }

    func testSomeValueRequiresAtLeastOneValueToMatch() throws {
        try assertDoesNotMatch("someValue:lessThan", value: [18, 21, 25], fact: 30)
    }

    func testDecoratorCompositionsMatch() throws {
        try assertAllMatch([
            ("everyFact:everyValue:lessThan", [100, 200, 300], [10, 20, 30]),
            ("everyFact:someValue:equal", ["a", "b", "c"], ["a", "c", "b"]),
            ("someFact:someValue:equal", ["premium", "vip"], ["basic", "trial", "vip"]),
            ("someFact:everyValue:greaterThan", [10, 20, 30], [5, 15, 50])
        ])
    }

    func testDecoratorCompositionsDoNotMatch() throws {
        try assertDoesNotMatch("everyFact:everyValue:lessThan",
                               value: [100, 200, 300],
                               fact: [10, 150, 30])
        try assertDoesNotMatch("everyFact:someValue:equal",
                               value: ["a", "b", "c"],
                               fact: ["a", "d", "b"])
    }

    // MARK: - Edge Cases

    func testFactDecoratorsRequireArrayFact() throws {
        try assertDoesNotMatch("everyFact:greaterThan", value: 50, fact: 60)
        try assertDoesNotMatch("someFact:greaterThan", value: 50, fact: 60)
    }

    func testEveryFactWithEmptyArrayMatches() throws {
        try assertMatches("everyFact:greaterThan", value: 50, fact: [] as [Int])
    }

    func testEveryValueWithNonArrayValueFallsBackToBaseOperator() throws {
        try assertMatches("everyValue:lessThan", value: 30, fact: 25)
    }

    func testUnknownDecoratorThrowsError() throws {
        let rule: [String: Any] = [
            "name": "test-rule",
            "conditions": [
                "all": [
                    [
                        "path": "$.fact",
                        "value": 50,
                        "operator": "unknownDecorator:greaterThan"
                    ] as [String: Any]
                ]
            ]
        ]

        XCTAssertThrowsError(try RuleEngine(rules: [rule], strategy: .strict))
    }

    func testDecoratorNormalization() throws {
        try assertMatches("every_fact:greater_than", value: 50, fact: [60, 70, 80])
    }

    func testOperatorWithoutDecorator() throws {
        try assertMatches("greaterThan", value: 18, fact: 25)
    }
}
