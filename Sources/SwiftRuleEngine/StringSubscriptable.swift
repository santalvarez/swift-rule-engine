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
 This conformance adds a subscript by string and optionally adds a static dictionary that maps
 snake-cased property names to their key paths for very fast dynamic lookup.
 */
@attached(extension, names: arbitrary)
public macro StringSubscriptable(withKeys: Bool = true) = #externalMacro(module: "SwiftRuleEngineMacros", type: "StringSubscriptableMacro")
