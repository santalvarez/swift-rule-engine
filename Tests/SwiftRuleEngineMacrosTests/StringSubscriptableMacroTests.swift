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
    func testMacroInStructWithGeneratedSwitch() throws {
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
                public subscript(key: String) -> Any? {
                    switch key {
                    case "attr":
                        return self.attr as Any
                    case "attr2":
                        return self.attr2 as Any
                    default:
                        return nil
                    }
                }
            }
            """,
            macros: testMacros
        )
    }

    func testMacroInClassWithGeneratedSwitch() throws {
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
                public subscript(key: String) -> Any? {
                    switch key {
                    case "attr":
                        return self.attr as Any
                    default:
                        return nil
                    }
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
                public subscript(key: String) -> Any? {
                    switch key {
                    case "first_name":
                        return self.firstName as Any
                    default:
                        return nil
                    }
                }
            }
            """,
            macros: testMacros
        )
    }

    func testMacroAcronymConversion() throws {
        assertMacroExpansion(
            """
            @StringSubscriptable
            struct S {
                let URLValue = "https://example.com"
                let teamID = "TEAM"
            }
            """,
            expandedSource: """
            struct S {
                let URLValue = "https://example.com"
                let teamID = "TEAM"
            }

            extension S: StringSubscriptable {
                public subscript(key: String) -> Any? {
                    switch key {
                    case "url_value":
                        return self.URLValue as Any
                    case "team_id":
                        return self.teamID as Any
                    default:
                        return nil
                    }
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
                public subscript(key: String) -> Any? {
                    switch key {
                    case "first_name":
                        return self.firstName as Any
                    default:
                        return nil
                    }
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
                public subscript(key: String) -> Any? {
                    switch key {
                    case "first_name":
                        return self.firstName as Any
                    default:
                        return nil
                    }
                }
            }
            """,
            macros: testMacros
        )
    }
}
