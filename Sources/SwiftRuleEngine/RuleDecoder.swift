//
//  RuleDecoder.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 17/09/2023.
//

import Foundation


let operatorsUserInfoKey = CodingUserInfoKey(rawValue: "operators")!

public class RuleDecoder {
    private let decoder = JSONDecoder()
    private let defaultOperators: [Operator.Type] = [Equal.self, NotEqual.self, LessThan.self, LessThanInclusive.self,
                                                     GreaterThan.self, GreaterThanInclusive.self, In.self, NotIn.self,
                                                     Contains.self, NotContains.self, Regex.self, NotRegex.self,
                                                     ContainsRegex.self, NotContainsRegex.self, StartsWith.self,
                                                     NotStartsWith.self, EndsWith.self, NotEndsWith.self]

    public init(_ operators: [Operator.Type] = []) throws {
        self.decoder.userInfo[operatorsUserInfoKey] = try generateOperatorsDict(operators)
    }

    private func generateOperatorsDict(_ customOperators: [Operator.Type]) throws -> [OperatorID:Operator.Type]{
        let operators = defaultOperators + customOperators

        return try operators.reduce(into: [:]) { result, op in
            guard result[op.id] == nil else {
                throw RuleEngineError.duplicateOperator
            }
            result[op.id] = op
        }
    }

    public func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        return try self.decoder.decode(type, from: data)
    }

    public func decodeRule(fromJSON json: String) throws -> Rule {
        guard let data = json.data(using: .utf8) else {
            throw RuleEngineError.invalidRule("Rule string is not valid UTF-8")
        }
        do {
            return try self.decode(Rule.self, from: data)
        } catch {
            throw RuleEngineError.invalidRule("Decoding failed: \(error)")
        }
    }

    public func decodeRule(fromDict dict: [String:Any]) throws -> Rule {
        let data: Data
        do {
            data = try JSONSerialization.data(withJSONObject: dict, options: [])
        } catch {
            throw RuleEngineError.invalidRule("Dictionary → JSON data failed: \(error)")
        }
        do {
            return try self.decode(Rule.self, from: data)
        } catch {
            throw RuleEngineError.invalidRule("Decoding failed: \(error)")
        }
    }
}
