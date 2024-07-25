//
//  CompilerPluginMain.swift
//
//
//  Created by Santiago Alvarez on 04/07/2024.
//

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct CompilerPluginMain: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        StringSubscriptableMacro.self
    ]
}
