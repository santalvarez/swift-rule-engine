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
                private static let keys: [String: PartialKeyPath<S>] = [
                    "attr": \\.attr,
                    "attr2": \\.attr2
                ]
                public subscript(key: String) -> Any? {
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
                private static let keys: [String: PartialKeyPath<C>] = [
                    "attr": \\.attr
                ]
                public subscript(key: String) -> Any? {
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

                public subscript(key: String) -> Any? {
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

                public subscript(key: String) -> Any? {
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
                private static let keys: [String: PartialKeyPath<C>] = [
                    "first_name": \\.firstName
                ]
                public subscript(key: String) -> Any? {
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

    func testMacroPrivatePropertyOmitted() throws {
        assertMacroExpansion(
            """
            @StringSubscriptable
            class C {
                let firstName = "Martin"
                private let age = 25
            }
            """,
            expandedSource: """
            class C {
                let firstName = "Martin"
                private let age = 25
            }

            extension C: StringSubscriptable {
                private static let keys: [String: PartialKeyPath<C>] = [
                    "first_name": \\.firstName
                ]
                public subscript(key: String) -> Any? {
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

    func testMacroStaticPropertyOmitted() throws {
        assertMacroExpansion(
            """
            @StringSubscriptable
            class C {
                let firstName = "Martin"
                static let age = 25
            }
            """,
            expandedSource: """
            class C {
                let firstName = "Martin"
                static let age = 25
            }

            extension C: StringSubscriptable {
                private static let keys: [String: PartialKeyPath<C>] = [
                    "first_name": \\.firstName
                ]
                public subscript(key: String) -> Any? {
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
