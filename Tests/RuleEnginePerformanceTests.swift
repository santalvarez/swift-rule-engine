//
//  RuleEnginePerformanceTests.swift
//
//
//  Created by Santiago Alvarez on 19/12/2023.
//

import XCTest
@testable import SwiftRuleEngine

final class RuleEnginePerformanceTests: XCTestCase {

    func testMultiConditionRulePerformance() throws {

        let rule = """
            {
                "name": "rule",
                "conditions": {
                    "all": [
                        {
                            "not": {
                                "all": [
                                    {
                                        "path": "$.player.id",
                                        "operator": "equal",
                                        "value": "124"
                                    },
                                    {
                                        "path": "$.player.name",
                                        "operator": "equal",
                                        "value": "Juan"
                                    }
                                ]
                            }
                        },
                        {
                            "path": "$.player.goals",
                            "operator": "greater_than",
                            "value": 200
                        },
                        {
                            "any": [
                                {
                                    "path": "$.player.country",
                                    "operator": "equal",
                                    "value": "Uruguay"
                                },
                                {
                                    "path": "$.player.country",
                                    "operator": "equal",
                                    "value": "Argentina"
                                }
                            ]
                        }
                    ]
                }
            }
        """

        let obj = [
            "player": [
                "id": "123",
                "name": "Martin",
                "goals": 205,
                "last_name": "Palermo",
                "country": "Argentina",
                "team": "Boca Juniors"
            ] as [String: Any]
        ]

        let engine = try! RuleEngine(rules: [rule])

        self.measure {
            for _ in 0..<140_000 {
                _ = engine.evaluate(obj)
            }
        }
    }

}
