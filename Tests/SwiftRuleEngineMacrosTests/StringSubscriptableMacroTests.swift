//
//  StringSubscriptableMacroTests.swift
//
//
//  Created by Santiago Alvarez on 04/07/2024.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

import SwiftRuleEngineMacros

let testMacros: [String: Macro.Type] = [
    "StringSubscriptable": StringSubscriptableMacro.self,
]

final class MhuntMacrosTests: XCTestCase {
    func testMacroInStructWithKeys() throws {
        assertMacroExpansion(
            """
            @StringSubscriptable
            struct S {
                let attr: Int = 123123
                let attr2: String = "hello"
            }
            """,
            expandedSource: """
            struct S {
                let attr: Int = 123123
                let attr2: String = "hello"
            }

            extension S: StringSubscriptable {
                private static let keys: [String: PartialKeyPath<Self>] = [
                    "attr": \\.attr,
                    "attr2": \\.attr2
                ]
                subscript(key: String) -> Any? {
                    guard let kp = Self.keys[key] else {
                        return nil
                    }
                    return self[keyPath: kp]
                }
            }
            """,
            macros: testMacros
        )
    }

    func testMacroInClassWithKeys() throws {
        assertMacroExpansion(
            """
            @StringSubscriptable
            class C {
                let attr = 123
            }
            """,
            expandedSource: """
            class C {
                let attr = 123
            }

            extension C: StringSubscriptable {
                private static let keys: [String: PartialKeyPath<Self>] = [
                    "attr": \\.attr
                ]
                subscript(key: String) -> Any? {
                    guard let kp = Self.keys[key] else {
                        return nil
                    }
                    return self[keyPath: kp]
                }
            }
            """,
            macros: testMacros
        )
    }

    func testMacroInStructWithoutKeys() throws {
        assertMacroExpansion(
            """
            @StringSubscriptable(withKeys: false)
            struct S {
                let attr: Int = 123123
            }
            """,
            expandedSource: """
            struct S {
                let attr: Int = 123123
            }

            extension S: StringSubscriptable {

                subscript(key: String) -> Any? {
                    guard let kp = Self.keys[key] else {
                        return nil
                    }
                    return self[keyPath: kp]
                }
            }
            """,
            macros: testMacros
        )
    }

    func testMacroInClassWithoutKeys() throws {
        assertMacroExpansion(
            """
            @StringSubscriptable(withKeys: false)
            class C {
                let attr = 123
            }
            """,
            expandedSource: """
            class C {
                let attr = 123
            }

            extension C: StringSubscriptable {

                subscript(key: String) -> Any? {
                    guard let kp = Self.keys[key] else {
                        return nil
                    }
                    return self[keyPath: kp]
                }
            }
            """,
            macros: testMacros
        )
    }


    func testMacroSnakeCaseConversion() throws {
        assertMacroExpansion(
            """
            @StringSubscriptable
            class C {
                let firstName = "Martin"
            }
            """,
            expandedSource: """
            class C {
                let firstName = "Martin"
            }

            extension C: StringSubscriptable {
                private static let keys: [String: PartialKeyPath<Self>] = [
                    "first_name": \\.firstName
                ]
                subscript(key: String) -> Any? {
                    guard let kp = Self.keys[key] else {
                        return nil
                    }
                    return self[keyPath: kp]
                }
            }
            """,
            macros: testMacros
        )
    }
}
