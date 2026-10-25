//
//  StringSubscriptableMacro.swift
//
//
//  Created by Santiago Alvarez on 04/07/2024.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import Foundation


enum StringSubscriptableMacroError: Error, CustomStringConvertible {
    case invalidAppliedType

    var description: String {
        switch self {
        case .invalidAppliedType: return "@StringSubscriptable is only applicable to Struct or Class types"
        }
    }
}

public struct StringSubscriptableMacro: ExtensionMacro {
    public static func expansion(of node: SwiftSyntax.AttributeSyntax,
                                 attachedTo declaration: some SwiftSyntax.DeclGroupSyntax,
                                 providingExtensionsOf type: some SwiftSyntax.TypeSyntaxProtocol,
                                 conformingTo protocols: [SwiftSyntax.TypeSyntax],
                                 in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.ExtensionDeclSyntax] {

        guard (declaration.is(StructDeclSyntax.self) || declaration.is(ClassDeclSyntax.self)),
              let typeName = type.as(IdentifierTypeSyntax.self) else {
            throw StringSubscriptableMacroError.invalidAppliedType
        }

        let lookup = Self.generateSwitch(with: declaration.memberBlock.members)
        let source = "extension \(typeName.name.text): StringSubscriptable {\n\(lookup)\n}"
        return [try ExtensionDeclSyntax("\(raw: source)")]
    }

    private static func generateSwitch(with members: MemberBlockItemListSyntax) -> String {
        var lines = [
            "    public subscript(key: String) -> Any? {",
            "        switch key {"
        ]
        let omittedModifiers = ["private", "static"]
        for m in members {
            guard let decl = m.decl.as(VariableDeclSyntax.self),
                  !decl.modifiers.contains(where: { omittedModifiers.contains($0.name.text) }),
                  let binding = decl.bindings.first,
                  let name = binding.pattern.as(IdentifierPatternSyntax.self) else {
                continue
            }
            let identifier = name.identifier.text
            let key = identifier.trimmingCharacters(in: CharacterSet(charactersIn: "`"))
            lines.append("        case \"\(camelCaseToSnakeCase(key))\": return self.\(identifier) as Any")
        }
        lines += [
            "        default: return nil",
            "        }",
            "    }"
        ]
        return lines.joined(separator: "\n")
    }

    private static func camelCaseToSnakeCase(_ input: String) -> String {
        // Split acronym-to-word boundaries first (URLValue -> URL_Value), then
        // ordinary camel-case boundaries (firstName -> first_Name).
        let patterns = ["([A-Z]+)([A-Z][a-z])", "([a-z0-9])([A-Z])"]
        var result = input
        for pattern in patterns {
            let regex = try! NSRegularExpression(pattern: pattern, options: [])
            let range = NSRange(result.startIndex..<result.endIndex, in: result)
            result = regex.stringByReplacingMatches(in: result, options: [], range: range, withTemplate: "$1_$2")
        }
        return result.lowercased()
    }
}
