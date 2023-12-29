# Operators

## Default Operators

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



## Custom Operator

To create your own operator you need to implement the `Operator` class.

```swift
import SwiftRuleEngine

struct EqualLowercase(Operator):
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
        return lhs == rhs.lowercased()
    }


// Load operator to engine
let engine = RuleEngine(rules: [...], customOperators=[EqualLowercase.Type])
```
