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
| priority | Priority of the rule. Higher-priority rules are evaluated first. Rules with equal priorities are evaluated in the order supplied. Defaults to 1. | int | no |
| conditions | A [multi condition](#multi-condition). All rules start with a multi condition. | dict | yes |
| extra | A dict that can be used to store extra information about the rule. | dict | no |

## Rule Evaluation Order

Rules are evaluated from highest to lowest priority. When multiple rules have the same priority, they are evaluated in the order they were supplied to the engine.

Rules without an explicit `priority` use the default priority of `1`. Therefore, if no rules specify a priority, they are evaluated in the supplied order.

When using the `.skip` loading strategy, only the first rule with a given name is retained. Later rules with the same name are discarded. The `.strict` strategy throws an error when duplicate rule names are found.

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
