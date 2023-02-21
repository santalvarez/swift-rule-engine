# swift-rule-engine
A rule engine written in Swift where rules are defined in JSON format


## Quick Example

```swift
import SwiftRuleEngine

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

let result = engine.evaluate(obj)

```
