# Operators

## Default Operators

Operator IDs are matched case-insensitively and accept both `snake_case` and `camelCase`
(underscores and dashes are ignored when matching).

| Operator             | ID                      | Description                                                                                                     | Supported Types   |
|----------------------|-------------------------|-----------------------------------------------------------------------------------------------------------------|-------------------|
| Equal                | "equal"                 | Compares if the value of the object is equal to the value of the condition.                                    | String, Int, Double, Bool, Array, Dictionary, nil |
| Not Equal            | "not_equal"             | Compares if the value of the object is not equal to the value of the condition.                                | String, Int, Double, Bool, Array, Dictionary, nil |
| Greater Than         | "greater_than"          | Compares if the value of the object is greater than the value of the condition.                                | String, Int, Double |
| Greater Than Inclusive| "greater_than_inclusive" | Compares if the value of the object is greater than or equal to the value of the condition.                  | String, Int, Double |
| Less Than            | "less_than"             | Compares if the value of the object is less than the value of the condition.                                   | String, Int, Double |
| Less Than Inclusive  | "less_than_inclusive"   | Compares if the value of the object is less than or equal to the value of the condition.                       | String, Int, Double |
| In                   | "in"                    | Compares if the value of the object is in the value of the condition. If possible, the value will be converted to a set for O(1) performance but only if the provided array is [AnyHashable]. | String, Array |
| Not In               | "not_in"                | Compares if the value of the object is not in the value of the condition. If possible, the value will be converted to a set for O(1) performance but only if the provided array is [AnyHashable]. | String, Array |
| Contains             | "contains"              | Compares if the value of the object contains the value of the condition.                                       | String, Int, Double, Bool, Array, Dictionary, nil |
| Not Contains         | "not_contains"          | Compares if the value of the object does not contain the value of the condition.                               | String, Int, Double, Bool, Array, Dictionary, nil |
| Regex                | "regex"                 | Checks if the object value matches the regex in the condition. The regex is compiled only when the rule is first loaded. | String |
| Not Regex            | "not_regex"             | Checks if the object value does not match the regex in the condition. The regex is compiled only when the rule is first loaded. | String |
| Contains Regex       | "contains_regex"        | Compares if the string array of the object contains the value of the condition using regex.                    | String |
| Not Contains Regex   | "not_contains_regex"    | Compares if the string array of the object does not contain the value of the condition using regex.            | String |
| Starts With          | "startswith"            | Compares if the value of the object starts with the value of the condition.                                    | String |
| Not Starts With      | "not_startswith"        | Compares if the value of the object does not start with the value of the condition.                            | String |
| Ends With            | "endswith"              | Compares if the value of the object ends with the value of the condition.                                      | String |
| Not Ends With        | "not_endswith"          | Compares if the value of the object does not end with the value of the condition.                              | String |



## Operator Decorators

Operator Decorators modify the behavior of an operator by changing how the input or output is processed. To use decorators, prefix the operator name with one or more decorator names separated by colons (`:`).

For example, `everyFact:greaterThan` creates an operator that checks if **every element** of a fact array is greater than the specified value.

> Decorator IDs are matched case-insensitively and accept both `snake_case` and `camelCase` (underscores and dashes are ignored when matching).

### Array Decorators

| Decorator | ID | Description |
|-----------|-----|-------------|
| Every Fact | `everyFact` | The fact (an array) must have **every element** pass the decorated operator for the value. |
| Some Fact | `someFact` | The fact (an array) must have **at least one element** pass the decorated operator for the value. |
| Every Value | `everyValue` | The fact must pass the decorated operator for **every element** of the value (an array). |
| Some Value | `someValue` | The fact must pass the decorated operator for **at least one element** of the value (an array). |

### Decorator Composition

Decorators can be composed by chaining them together with colons. They are applied from right to left (innermost first).

For example, `everyFact:everyValue:lessThan` means:
- For **every element** in the fact array
- Check that it is less than **every element** in the value array

### Examples

**everyFact:greaterThan** - All scores must be greater than 50:
```json
{
    "path": "$.scores",
    "operator": "everyFact:greaterThan",
    "value": 50
}
```
```swift
// Matches: {"scores": [60, 70, 80, 90]}
// Fails:   {"scores": [60, 40, 80, 90]}  // 40 is not > 50
```

**someFact:equal** - At least one tag must equal "premium":
```json
{
    "path": "$.tags",
    "operator": "someFact:equal",
    "value": "premium"
}
```
```swift
// Matches: {"tags": ["basic", "premium", "trial"]}
// Fails:   {"tags": ["basic", "standard", "trial"]}
```

**everyValue:lessThan** - Age must be less than all threshold values:
```json
{
    "path": "$.age",
    "operator": "everyValue:lessThan",
    "value": [30, 40, 50]
}
```
```swift
// Matches: {"age": 25}  // 25 < 30, 25 < 40, 25 < 50
// Fails:   {"age": 35}  // 35 is not < 30
```

**someValue:equal** - Status must match at least one allowed value:
```json
{
    "path": "$.status",
    "operator": "someValue:equal",
    "value": ["active", "pending", "approved"]
}
```
```swift
// Matches: {"status": "pending"}
// Fails:   {"status": "rejected"}
```

**everyFact:someValue:equal** - Every tag must be one of the allowed values:
```json
{
    "path": "$.tags",
    "operator": "everyFact:someValue:equal",
    "value": ["a", "b", "c"]
}
```
```swift
// Matches: {"tags": ["a", "c", "b"]}
// Fails:   {"tags": ["a", "d", "b"]}  // "d" is not in allowed values
```

**someFact:everyValue:greaterThan** - At least one score must be greater than all thresholds:
```json
{
    "path": "$.scores",
    "operator": "someFact:everyValue:greaterThan",
    "value": [10, 20, 30]
}
```
```swift
// Matches: {"scores": [5, 15, 50]}  // 50 > 10, 50 > 20, 50 > 30
// Fails:   {"scores": [5, 15, 25]}  // No single score is > all thresholds
```

---

## Custom Operator

To create your own operator you need to implement the `Operator` protocol.

```swift
import SwiftRuleEngine

struct EqualLowercase: Operator {
    static let id = OperatorID(rawValue: "equal_lowercase")
    private let value: String

    init(value: AnyCodable, params: [String : Any]?) throws {
        switch value {
        case .string(let string):
            self.value = string.lowercased()
        default:
            throw OperatorError.invalidValueType
        }
    }

    func match(_ objValue: Any) -> Bool {
        guard let rhs = objValue as? String else {
            return false
        }
        return value == rhs.lowercased()
    }
}

// Load operator to engine
let engine = try RuleEngine(rules: [...], customOperators: [EqualLowercase.self])
```
