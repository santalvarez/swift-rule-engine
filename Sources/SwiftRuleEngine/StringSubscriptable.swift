//
//  StringSubscriptable.swift
//  
//
//  Created by Santiago Alvarez on 15/06/2024.
//

import Foundation


public protocol StringSubscriptable {
    associatedtype Value

    subscript(key: String) -> Value? { get }
}

/**
 This macro adds an extension to a **Class** or **Struct** that conforms to the **StringSubscriptable**.
 The conformance uses a generated switch to map snake-cased property names to their values.
 For custom mappings, conform to `StringSubscriptable` directly and implement its subscript.
 */
@attached(extension, names: arbitrary, conformances: StringSubscriptable)
public macro StringSubscriptable() = #externalMacro(module: "SwiftRuleEngineMacros", type: "StringSubscriptableMacro")
