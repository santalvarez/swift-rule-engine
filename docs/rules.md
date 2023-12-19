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

**name(str, req):** The name of the rule

**conditions(dict, req):** A [multi condition](#multi-condition). Defining a simple condition in here is not allowed, it needs to be inside a multi condition.

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

**operator(str, req):** The operator to use to compare the object with the defined value. Find info on built-in operators and how to define your own [here](operators.md).

**path(str):** A [JSONPath](https://goessner.net/articles/JsonPath/) expression indicating what attribute of the object to evaluate.

**value(any, req):** The value that will be used to compare with the object.

**params(dict):** A dict that can provide the operator more information about how to process the object.


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

**all(list):** All conditions inside have to match.

**any(list):** One of the conditions inside have to match.

**not(dict):** The result of the condition inside will be negated.


## Results

A rule result has the same structure as a rule but with two added fields.

**match(bool):** Indicates wether the condition matched.
