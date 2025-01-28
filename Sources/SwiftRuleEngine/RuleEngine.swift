//
//  RuleEngine.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 21/12/2022.
//

import Foundation


enum RuleEngineError: Error {
    case operatorNotFound
    case duplicateOperator
    case invalidRule(String)
    case duplicateRuleName(String)
}

final public class RuleEngine {
    private var rulesDict: [String: Rule] = [:]
    private var rules: [Rule] = []
    private let ruleDecoder: RuleDecoder


    public init(rules: [String], customOperators: [Operator.Type] = []) throws {
        self.ruleDecoder = try RuleDecoder(customOperators)
        let decodedRules = rules.compactMap{ dictRule in
            try? decodeRule(rule: dictRule)
        }
        try initializeRules(decodedRules)
    }

    public init(rules: [[String: Any]], customOperators: [Operator.Type] = []) throws {
        self.ruleDecoder = try RuleDecoder(customOperators)
        let decodedRules = rules.compactMap{ dictRule in
            try? decodeRule(rule: dictRule)
        }
        try initializeRules(decodedRules)
    }

    public init(rules: [Rule], customOperators: [Operator.Type] = []) throws {
        self.ruleDecoder = try RuleDecoder(customOperators)
        try initializeRules(rules)
    }
    
    private func initializeRules(_ rules: [Rule]) throws {
        var ruleNamesSet = Set<String>()
        self.rulesDict = try rules.reduce(into: [:]) { dict, rule in
            if !ruleNamesSet.insert(rule.name).inserted {
                throw RuleEngineError.duplicateRuleName("Duplicate rule name found: '\(rule.name)'")
            }
            dict[rule.name] = rule
        }
        self.rules = rules
    }

    private func decodeRule(rule: [String: Any]) throws -> Rule {
        guard let ruleData = try? JSONSerialization.data(withJSONObject: rule, options: []) else {
            throw RuleEngineError.invalidRule("Error converting dict to data")
        }

        guard let rule = try? ruleDecoder.decode(Rule.self, from: ruleData) else {
            throw RuleEngineError.invalidRule("Error decoding rule")
        }
        return rule
    }

    private func decodeRule(rule: String) throws -> Rule {
        guard let ruleData = rule.data(using: .utf8) else {
            throw RuleEngineError.invalidRule("Rule not in utf8 format")
        }

        guard let rule = try? ruleDecoder.decode(Rule.self, from: ruleData) else {
            throw RuleEngineError.invalidRule("Error decoding rule")
        }
        return rule
    }

    public func evaluate(_ obj: Any) -> Rule? {
        let sortedRules = rules.sorted { $0.priority > $1.priority }
        for rule in sortedRules {
            var rule = rule
            guard ((try? rule.conditions.evaluate(obj)) != nil) else {
                continue
            }
            if rule.conditions.match {
                return rule
            }
        }
        return nil
    }
    
    public func evaluateRule(named ruleName: String, with object: Any) -> Rule? {
        guard var rule = rulesDict[ruleName] else {
            return nil
        }
        guard ((try? rule.conditions.evaluate(object)) != nil) else {
            return nil
        }
        if rule.conditions.match {
            return rule
        }
        return nil
    }
}
