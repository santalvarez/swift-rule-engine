// swift-tools-version:5.8
//
//  Package.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 06/06/2023.
//

import PackageDescription


let package = Package(
    name: "SwiftRuleEngine",
    platforms: [
        .macOS(.v10_15),
    ],
    products: [
        .library(name: "SwiftRuleEngine", targets: ["SwiftRuleEngine"])
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "SwiftRuleEngine", dependencies: []),
        .testTarget(name: "SwiftRuleEngineTests", dependencies: ["SwiftRuleEngine"])
    ]
)
