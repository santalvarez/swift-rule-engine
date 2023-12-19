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


    public init(rules: [String], customOperators: [Operator.Type] = []) throws {
        self.ruleDecoder = try RuleDecoder(customOperators)
        self.rules = rules.compactMap{ dictRule in
            try? decodeRule(rule: dictRule)
        }
    }

    public init(rules: [[String: Any]], customOperators: [Operator.Type] = []) throws {
        self.ruleDecoder = try RuleDecoder(customOperators)
        self.rules = rules.compactMap{ dictRule in
            try? decodeRule(rule: dictRule)
        }
    }

    public init(rules: [Rule], customOperators: [Operator.Type] = []) throws {
        self.ruleDecoder = try RuleDecoder(customOperators)
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

    private func runCondition(_ condition: inout SimpleCondition, _ obj: Any) throws {
        let pathObj: Any
        if condition.path != nil {
            pathObj = try condition.path!.getValue(for: obj)
        } else {
            pathObj = obj
        }

        condition.match = condition.op.match(pathObj)
    }

    private func runMultiConditionAll(_ multiCondition: inout MultiCondition, _ obj: Any) throws {
        for (idx, condition) in multiCondition.all!.enumerated() {
            let result: Condition

            switch condition {
            case .multi(var cond):
                try self.runMultiCondition(&cond, obj)
                result = Condition.multi(cond)

            case .simple(var cond):
                try self.runCondition(&cond, obj)
                result = Condition.simple(cond)
            }

            multiCondition.all![idx] = result

            if !result.getMatch() {
                multiCondition.match = false
                return
            }
        }

        multiCondition.match = true
    }

    private func runMultiConditionAny(_ multiCondition: inout MultiCondition, _ obj: Any) throws {
        for (idx, condition) in multiCondition.any!.enumerated() {
            let result: Condition

            switch condition {
            case .multi(var cond):
                try self.runMultiCondition(&cond, obj)
                result = Condition(cond)

            case .simple(var cond):
                try self.runCondition(&cond, obj)
                result = Condition(cond)
            }

            multiCondition.any![idx] = result

            if result.getMatch() {
                multiCondition.match = true
                return
            }
        }

        multiCondition.match = false
    }

    private func runMultiConditionNot(_ multiCondition: inout MultiCondition, _ obj: Any) throws {
        let result: Condition

        switch multiCondition.not! {
        case .multi(var cond):
            try self.runMultiCondition(&cond, obj)
            result = Condition(cond)
        case .simple(var cond):
            try self.runCondition(&cond, obj)
            result = Condition(cond)
        }

        multiCondition.not = result
        multiCondition.match = !result.getMatch()
    }

    private func runMultiCondition(_ multiCondition: inout MultiCondition, _ obj: Any) throws {
        if multiCondition.all != nil {
            try self.runMultiConditionAll(&multiCondition, obj)
        } else if multiCondition.any != nil {
            try self.runMultiConditionAny(&multiCondition, obj)
        } else if multiCondition.not != nil {
            try self.runMultiConditionNot(&multiCondition, obj)
        }
    }

    public func evaluate(_ obj: [String: Any]) -> Rule? {
        for rule in self.rules {
            var rule = rule
            guard (try? self.runMultiCondition(&rule.conditions, obj)) != nil else {
                continue
            }

            if rule.conditions.match {
                return rule
            }
        }
        return nil
    }
}
