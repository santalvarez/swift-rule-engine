# Operators

## Default Operators

### Equal

- **id**: "equal"

- **description**: Compares if the value of the object is equal to the value of the condition.


### Not Equal

- **id**: "not_equal"
- **description**: Compares if the value of the object is not equal to the value of the condition.


### Greater Than

- **id**: "greater_than"

- **description**: Compares if the value of the object is greater than the value of the condition.


### Greater Than Inclusive

- **id**: "greater_than_inclusive"

- **description**: Compares if the value of the object is greater than or equal to the value of the condition.


### Less Than

- **id**: "less_than"

- **description**: Compares if the value of the object is less than the value of the condition.


### Less Than Inclusive

- **id**: "less_than_inclusive"

- **description**: Compares if the value of the object is less than or equal to the value of the condition.


### In

- **id**: "in"

- **description**: Compares if the value of the object is in the value of the condition.


### Not In

- **id**: "not_in"

- **description**: Compares if the value of the object is not in the value of the condition.


### Contains

- **id**: "contains"

- **description**: Compares if the value of the object contains the value of the condition.


### Not Contains

- **id**: "not_contains"

- **description**: Compares if the value of the object does not contain the value of the condition.


### Regex

- **id**: "regex"

- **description**: Checks if the object value matches the regex in the condition. The regex is compiled 
and cached to improve performance.


## Custom Operator

To create your own operator you need to implement the `Operator` class.

```swift
import SwiftRuleEngine

extension OperatorID {
    static let equal_lowercase = OperatorID(rawValue: "equal_lowercase")
}

struct EqualLowercase(Operator):
    let id = OperatorID.equal_lowercase

    func match(_ condition: SimpleCondition, _ objValue: Any) -> Bool {
        guard condition.value.valueType == .string,
              let lhs = condition.value.value as? String,
              let rhs = objValue as? String else {
            return false
        }
        return lhs.lowercased() == rhs.lowercased()
    }


# Load operator to engine
let engine = RuleEngine(rules: [...], customOperators=[EqualLowercase()])
```
