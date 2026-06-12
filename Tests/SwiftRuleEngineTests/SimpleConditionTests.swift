//
//  SimpleConditionTests.swift
//
//
//  Created by Santiago Alvarez on 27/12/2023.
//

import XCTest
@testable import SwiftRuleEngine

final class SimpleConditionTests: XCTestCase {
    private var decoder: RuleDecoder!

    override func setUp() {
        self.decoder = try! RuleDecoder()
    }

}
