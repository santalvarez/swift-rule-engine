# Macros

## StringSubscriptable

This macro is used to add a subscript to a `class` or `struct` that allows it to
be accessed like a dictionary. The subscript receives a string key and returns
an optional value. The key is used to access a property of the type using a `KeyPath`.

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
    private static let keys: [String: PartialKeyPath<Self>] = [
        "first_name": \.firstName,
    ]
    subscript(key: String) -> Any? {
        guard let kp = Self.keys[key] else {
            return nil
         }
         return self[keyPath: kp]
    }
}
```

It should be noted that the `withKeys` macro argument is true by default adds a static private dictionary
mapping snake-cased keys to their `KeyPath`. In case users want to define their own string to `KeyPath`
mapping they can set `withKeys` to false.