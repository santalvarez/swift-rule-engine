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
    case duplicateRuleName
    case invalidRule(String)
}

public enum RuleLoadingStrategy {
  /// If any rule fails to load or there are duplicate rules, throw immediately.
  case strict
  /// Silently drop any rules that fail to load or there are duplicate rules.
  /// If there are duplicate rules, the first one is kept.
  case skip
}

public final class RuleEngine {
  private var rules: [Rule]
  private let ruleDecoder: RuleDecoder

  /// Initialize from an array of JSON strings
  public convenience init(rules jsonStrings: [String],
                          strategy: RuleLoadingStrategy = .skip,
                          customOperators: [Operator.Type] = []) throws {
    // build a decoder
    let decoder = try RuleDecoder(customOperators)

    // decode each JSON string to a Rule based on strategy
    let decoded = try jsonStrings.compactMap { jsonString in
      do {
        return try decoder.decodeRule(fromJSON: jsonString)
      } catch {
        if strategy == .strict { throw error }
        return nil // skipInvalid: silently drop failed rules
      }
    }

    // call the designated init
    try self.init(rules: decoded, customOperators: customOperators, strategy: strategy)
  }

  /// Initialize from an array of dictionaries
  public convenience init(rules dictArray: [[String:Any]],
                          strategy: RuleLoadingStrategy = .skip,
                          customOperators: [Operator.Type] = []) throws {
    let decoder = try RuleDecoder(customOperators)

    // decode each dictionary to a Rule based on strategy
    let decoded = try dictArray.compactMap { dict in
      do {
        return try decoder.decodeRule(fromDict: dict)
      } catch {
        if strategy == .strict { throw error }
        return nil // skipInvalid: silently drop failed rules
      }
    }

    try self.init(rules: decoded, customOperators: customOperators, strategy: strategy)
  }

  public init(rules: [Rule], customOperators: [Operator.Type] = [],
              strategy: RuleLoadingStrategy = .skip) throws {
    self.ruleDecoder = try RuleDecoder(customOperators)

    // Handle duplicate rules based on strategy
    if strategy == .strict && Dictionary(grouping: rules, by: { $0.name }).contains(where: { $1.count > 1 }) {
      throw RuleEngineError.duplicateRuleName
    }

    self.rules = Array(Dictionary(grouping: rules, by: { $0.name }).values.map { $0.first! })
      .sorted { $0.priority > $1.priority }
  }

  public func evaluate(_ obj: Any) -> Rule? {
    for rule in rules {
      // Use the non-mutating evaluation method to avoid copying rules
      do {
        if try rule.conditions.evaluateAndMatch(obj) {
          return rule
        }
      } catch {
        // Continue to next rule if evaluation fails
        continue
      }
    }
    return nil
  }
}
