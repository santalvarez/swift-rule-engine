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

- **description**: Compares if the value of the object is in the value of the condition. If possible the value
                   will be converted to a set for O(1) performance but only if the provided array is [AnyHashable].


### Not In

- **id**: "not_in"

- **description**: Compares if the value of the object is not in the value of the condition. If possible the value
                   will be converted to a set for O(1) performance but only if the provided array is [AnyHashable].


### Contains

- **id**: "contains"

- **description**: Compares if the value of the object contains the value of the condition.


### Not Contains

- **id**: "not_contains"

- **description**: Compares if the value of the object does not contain the value of the condition.


### Regex

- **id**: "regex"

- **description**: Checks if the object value matches the regex in the condition. The regex is compiled
only when the rule is first loaded.


### Contains Regex

- **id**: "contains_regex"

- **description**: Compares if the string array of the object contains the value of the condition using regex.


### Not Contains Regex

- **id**: "not_contains_regex"

- **description**: Compares if the string array of the object does not contain the value of the condition using regex.


## Custom Operator

To create your own operator you need to implement the `Operator` class.

```swift
import SwiftRuleEngine

struct EqualLowercase(Operator):
    static let id = OperatorID(rawValue: "equal_lowercase")
    private let value: String
    
    init(value: AnyCodable, params: [String : Any]?) throws {
        guard let valueStr = value as? String else {
            throw OperatorError.invalidValueType
        }
        self.value = valueStr.lowercased()
    }

    func match(_ objValue: Any) -> Bool {
        guard let rhs = objValue as? String else {
            return false
        }
        return lhs == rhs.lowercased()
    }


# Load operator to engine
let engine = RuleEngine(rules: [...], customOperators=[EqualLowercase.Type])
```
