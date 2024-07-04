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
    case withKeysInvalidType

    var description: String {
        switch self {
        case .invalidAppliedType: return "@StringSubscriptable is only applicable to Struct or Class types"
        case .withKeysInvalidType: return "withKeys attribute must be a boolean"
        }
    }
}

public struct StringSubscriptableMacro: ExtensionMacro {
    public static func expansion(of node: SwiftSyntax.AttributeSyntax,
                                 attachedTo declaration: some SwiftSyntax.DeclGroupSyntax,
                                 providingExtensionsOf type: some SwiftSyntax.TypeSyntaxProtocol,
                                 conformingTo protocols: [SwiftSyntax.TypeSyntax],
                                 in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.ExtensionDeclSyntax] {

        var generateKeys = true
        if let args = node.arguments?.as(LabeledExprListSyntax.self) {
            for arg in args {
                if arg.label?.text != "withKeys" { continue }
                guard let withKeysValue = arg.expression.as(BooleanLiteralExprSyntax.self) else {
                    throw StringSubscriptableMacroError.withKeysInvalidType
                }
                if withKeysValue.literal.text == "false" { generateKeys = false }
            }
        }

        guard (declaration.is(StructDeclSyntax.self) || declaration.is(ClassDeclSyntax.self)),
              let typeName = type.as(IdentifierTypeSyntax.self) else {
            throw StringSubscriptableMacroError.invalidAppliedType
        }

        let keys = generateKeys ? Self.generateKeys(members: declaration.memberBlock.members) : ""

        return [try ExtensionDeclSyntax("""
        extension \(raw: typeName.name.text): StringSubscriptable {
            \(keys)
            subscript(key: String) -> Any? {
                guard let kp = Self.keys[key] else {
                    return nil
                }
                return self[keyPath: kp]
            }
        }
        """)]
    }

    private static func generateKeys(members: MemberBlockItemListSyntax) -> DeclSyntax {
        var keys: [String] = []
        for m in members {
            guard let decl = m.decl.as(VariableDeclSyntax.self),
                  let binding = decl.bindings.first,
                  let name = binding.pattern.as(IdentifierPatternSyntax.self) else {
                continue
            }
            keys.append("\"\(camelCaseToSnakeCase(name.identifier.text))\": \\.\(name)")
        }
        let tab = "    "
        keys = keys.map { "\(tab)\($0)" }

        return """
        private static let keys: [String: PartialKeyPath<Self>] = [
        \(raw: keys.joined(separator: ",\n"))
        ]
        """
    }

    private static func camelCaseToSnakeCase(_ input: String) -> String {
        // Create a regular expression to match the boundaries between lowercase and uppercase letters
        let pattern = "([a-z])([A-Z])"
        let regex = try! NSRegularExpression(pattern: pattern, options: [])

        // Perform the replacement operation
        let range = NSRange(location: 0, length: input.count)
        let snakeCase = regex.stringByReplacingMatches(in: input, options: [], range: range, withTemplate: "$1_$2")

        // Convert to lowercase
        return snakeCase.lowercased()
    }
}
