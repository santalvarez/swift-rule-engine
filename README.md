# swift-rule-engine
A rule engine written in Swift where rules are defined in JSON format.

- [Rule Syntax](docs/rules.md)

## Installation

### CocoaPods
```ruby
pod 'SwiftRuleEngine'
```

### Swift Package Manager
```swift
dependencies: [
    .package(url: "https://github.com/santalvarez/swift-rule-engine.git",
             from: upToNextMajor("1.4.0"))
]
```

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

## Advanced Example

```swift
import SwiftRuleEngine

let rule = """
    {
      "name": "advanced-rule",
      "extra": {"author": "Santiago Alvarez"},
      "conditions": {
          "all": [
              {
                  "path": "$.player.first_name",
                  "value": "Lionel",
                  "operator": "equal"
              },
              {
                  "path": "$.player.clubs",
                  "operator": "contains"
                  "value": ["Boca Juniors", "Juventus", "PSG"],
                  "params": {"mode": "any"}
              },
              {
                "path": "$.player.last_name",
                "operator": "in",
                "value": ["Messi", "Ronaldo", "Neymar"]
              },
              {
                  "any": [
                      {
                          "path": "$.player.age",
                          "operator": "less_than",
                          "value": 35
                      },
                      {
                          "path": "$.player.goals",
                          "operator": "greater_than",
                          "value": 600
                      }
                  ]
              }
          ]
      }
  }
"""

let obj = [
    "player": [
        "first_name": "Lionel",
        "last_name": "Messi",
        "age": 34,
        "goals": 700,
        "clubs": [
            "Barcelona",
            "PSG",
            "InterMiami"
        ]
    ]
]

let engine = try RuleEngine(rules: [rule])

let result = engine.evaluate(obj)
```
