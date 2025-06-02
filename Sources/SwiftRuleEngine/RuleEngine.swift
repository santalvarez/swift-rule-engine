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
}

final public class RuleEngine {
    private var rules: [Rule] = []
    private let ruleDecoder: RuleDecoder

    private var ruleIndexByName: [String:Int] = [:]

    public convenience init(rules: [String], customOperators: [Operator.Type] = []) throws {
        let ruleDecoder = try RuleDecoder(customOperators)
        let decodedRules = rules.compactMap { dictRule -> Rule? in
            guard let data = dictRule.data(using: .utf8) else { return nil }
            return try? ruleDecoder.decode(Rule.self, from: data)
        }
        try self.init(rules: decodedRules, customOperators: customOperators)
    }

    public convenience init(rules: [[String: Any]], customOperators: [Operator.Type] = []) throws {
        let ruleDecoder = try RuleDecoder(customOperators)
        let decodedRules = rules.compactMap { dictRule -> Rule? in
            guard let data = try? JSONSerialization.data(withJSONObject: dictRule, options: []) else { return nil }
            return try? ruleDecoder.decode(Rule.self, from: data)
        }
        try self.init(rules: decodedRules, customOperators: customOperators)
    }

    public init(rules: [Rule], customOperators: [Operator.Type] = []) throws {
        self.ruleDecoder = try RuleDecoder(customOperators)
        self.rules = rules
        self.rules.sort { $0.priority > $1.priority }

        for (index, rule) in self.rules.enumerated() {
            self.ruleIndexByName[rule.name] = index
        }
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
        for rule in rules {
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

    public func evaluateRule(_ obj: Any, ruleName: String) -> Rule? {
        // Retrieve the index for the requested rule name
        guard let index = ruleIndexByName[ruleName], index < rules.count else {
            return nil
        }

        var rule = rules[index]

        // Try evaluating the conditions against the provided object
        guard ((try? rule.conditions.evaluate(obj)) != nil) else {
            return nil
        }

        return rule.conditions.match ? rule : nil
    }
}
