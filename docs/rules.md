# Rules

A basic rule consists of a name and a multi condition
```json
{
    "name": "test-rule",
    "conditions": {
        "all": [
            {""" condition1 """},
            {""" condition2 """}
        ]
    }
}
```

| key | description | type | required |
| --- | --- | --- | --- |
| name | The name of the rule | str | yes |
| description | A description of the rule. | str | no |
| conditions | A [multi condition](#multi-condition). All rules start with a multi condition. | dict | yes |
| extra | A dict that can be used to store extra information about the rule. | dict | no |

## Condition Types

### Simple Condition

A simple condition consists of an operator and a value.

```json
{
    "path" : "$.person.name",
    "operator": "equal",
    "value": "John"
}
```

Table describing the keys:

| key | description | type | required |
| --- | --- | --- | --- |
| operator | The operator to use to compare the object with the defined value. Find info on built-in operators and how to define your own [here](operators.md). | str | yes |
| path | A [JSONPath](https://goessner.net/articles/JsonPath/) expression indicating what attribute of the object to evaluate. Appart from accessing attributes it also supports accessing array elements by [index]. | str | no |
| value | The value that will be used to compare with the object. | any | yes |
| params | A dict that can provide the operator more information about how to process the object. | dict | no |


#### Mode Param
You can use the param "mode" to avoid repeating the same operator for different types of values. The mode param can be either "any" or "all" and behaves just like the multi condition.

Here is an example of two rules that do the same thing but one uses the mode param and the other doesn't.

```json
{
    "name": "rule",
    "conditions": {
        "all": [
            {
                "path" : "$.person.last_name",
                "operator": "equal",
                "value": "Doe"
            },
            {
                "any": [
                    {
                        "path" : "$.person.name",
                        "operator": "equal",
                        "value": "John"
                    },
                    {
                        "path" : "$.person.name",
                        "operator": "equal",
                        "value": "Jane"
                    }
                ]
            }
        ]
    }
}

{
    "name": "rule-with-mode",
    "conditions": {
        "all": [
            {
                "path" : "$.person.last_name",
                "operator": "equal",
                "value": "Doe"
            },
            {
                "path" : "$.person.name",
                "operator": "equal",
                "value": ["John", "Jane"],
                "params": {"mode": "any"}
            }
        ]
    }
}
```
As you can see the second rule is much more compact and easier to write. When using the mode param the value must be a **list of values** as the operator will be loaded with each value in the list.


### Multi Condition

Contains either **any**, **all** or **not** fields. These fields contain conditions that can be simple, multi or a mix of both.

```json
{
    "all": [
        {
            "operator": "equal",
            "path": "$.person.name",
            "value": "John"
        },
        {
            "not": {
                "all": [
                    {""" condition """}
                ]
            }
        }
        {
            "any": [
                {""" condition """}
            ]
        }
    ]
}
```

Only one of these fields can be present in a multi condition.
| key | description | type |
| --- | --- | --- |
| all | All conditions inside have to match. | list |
| any | One of the conditions inside have to match. | list |
| not | The result of the condition inside will be negated. | dict |


## Results

A rule result has the same structure as a rule but with one added field.

**match(bool):** Indicates wether the condition matched.
