# Macros

## StringSubscriptable

This macro is used to add a subscript to a `class` or `struct` that allows it to
be accessed like a dictionary. The subscript receives a string key and returns
an optional value. A generated switch maps snake-cased keys directly
to the type's properties.

It can be used as follows:
```swift
import SwiftRuleEngine

@StringSubscriptable
struct S {
    let firstName = "Santiago"
}
```

And when the program is compiled, it will add the following extension to the applied type:
```swift
extension S: StringSubscriptable {
    public subscript(key: String) -> Any? {
        switch key {
        case "first_name":
            return self.firstName as Any
        default:
            return nil
        }
    }
}
```

For custom mappings, conform to `StringSubscriptable` directly and implement
the subscript yourself.
