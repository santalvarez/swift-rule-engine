# swift-rule-engine
A rule engine written in Swift where rules are defined in JSON format.

- [Rule Syntax](docs/rules.md)
- [Operators](docs/operators.md)
- [Macros](docs/macros.md)

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

let rule: [String: Any] = [
    "name": "advanced-rule",
    "extra": ["author": "Santiago Alvarez"],
    "conditions": [
        "all": [
            [
                "path": "$.player.first_name",
                "value": "Lionel",
                "operator": "equal"
            ],
            [
                "path": "$.player.clubs",
                "operator": "contains"
                "value": ["Boca Juniors", "Juventus", "PSG"],
                "params": ["mode": "any"]
            ],
            [
              "path": "$.player.last_name",
              "operator": "in",
              "value": ["Messi", "Ronaldo", "Neymar"]
            ],
            [
              "path": "$.player.age",
              "operator": "less_than",
              "value": 35
            ],
            [
              "path": "$.player.clubs[0]",
              "operator": "equal",
              "value": "Barcelona"
            ]
        ]
    ]
]

@StringSubscriptable
struct Club {
    let name: String
    let country: String
}

@StringSubscriptable
struct Player {
    let first_name: String
    let last_name: String
    let age: Int
    let goals: Int
    let clubs: [String]
}

let obj: [String: Any] = [
    "player": Player(
        first_name: "Lionel",
        last_name: "Messi",
        age: 34,
        goals: 700,
        clubs: [
            Club(name: "Barcelona", country: "Spain"),
            Club(name: "PSG", country: "France"),
            Club(name: "InterMiami", country: "USA")
        ]
    )
]

let engine = try RuleEngine(rules: [rule])

let result = engine.evaluate(obj)
```
