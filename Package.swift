// swift-tools-version:6.1
//
//  Package.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 06/06/2023.
//

import PackageDescription
import CompilerPluginSupport


let package = Package(
    name: "SwiftRuleEngine",
    platforms: [
        .macOS(.v10_15),
    ],
    products: [
        .library(name: "SwiftRuleEngine", targets: ["SwiftRuleEngine"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", from: "600.0.1"),
    ],
    targets: [
        .target(
            name: "SwiftRuleEngine",
            dependencies: ["SwiftRuleEngineMacros"],
            path: "Sources/SwiftRuleEngine"
        ),
        .testTarget(
            name: "SwiftRuleEngineTests",
            dependencies: ["SwiftRuleEngine"],
            path: "Tests/SwiftRuleEngineTests"
        ),
        .macro(
            name: "SwiftRuleEngineMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ],
            path: "Sources/SwiftRuleEngineMacros"
        ),
        .testTarget(
            name: "SwiftRuleEngineMacrosTests",
            dependencies: [
                "SwiftRuleEngineMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ],
            path: "Tests/SwiftRuleEngineMacrosTests"
        )
    ],
    swiftLanguageModes: [.v5]
)
