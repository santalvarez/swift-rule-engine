//
//  OperatorDecorator.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 28/01/2026.
//

import Foundation


public typealias OperatorFactory = (AnyCodable) throws -> Operator

public protocol OperatorDecorator {
    static var id: DecoratorID { get }

    /// Builds and wraps the inner operator chain with modified behavior.
    /// - Parameters:
    ///   - makeOperator: A factory that builds the inner operator chain for a rule value
    ///   - value: The value from the condition
    static func decorate(_ makeOperator: OperatorFactory, value: AnyCodable) throws -> Operator
}

public struct DecoratorID: RawRepresentable, Hashable, Equatable, Sendable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    static func normalize(_ raw: String) -> String {
        raw.lowercased()
           .replacingOccurrences(of: "_", with: "")
           .replacingOccurrences(of: "-", with: "")
    }
}


struct DecoratedOperator: Operator {
    static var id: OperatorID { OperatorID(rawValue: "decorated") }

    private let matchFunction: (Any) -> Bool

    init(matchFunction: @escaping (Any) -> Bool) {
        self.matchFunction = matchFunction
    }

    init(value: AnyCodable, params: [String: Any]?) throws {
        fatalError("DecoratedOperator should be created via decoration, not directly")
    }

    func match(_ objValue: Any) -> Bool {
        matchFunction(objValue)
    }
}

// everyFact - fact (array) must have every element pass the operator for value
struct EveryFactDecorator: OperatorDecorator {
    static let id = DecoratorID(rawValue: "everyFact")

    static func decorate(_ makeOperator: OperatorFactory, value: AnyCodable) throws -> Operator {
        let op = try makeOperator(value)

        return DecoratedOperator { objValue in
            // Cast through NSArray first because Swift arrays are not covariant
            // ([Int] cannot be directly cast to [Any], but NSArray bridges properly)
            guard let array = objValue as? NSArray else {
                return false // Not an array, fail
            }
            return array.allSatisfy { op.match($0) }
        }
    }
}

// someFact - fact (array) must have at-least one element pass the operator
struct SomeFactDecorator: OperatorDecorator {
    static let id = DecoratorID(rawValue: "someFact")

    static func decorate(_ makeOperator: OperatorFactory, value: AnyCodable) throws -> Operator {
        let op = try makeOperator(value)

        return DecoratedOperator { objValue in
            // Cast through NSArray first because Swift arrays are not covariant
            guard let array = objValue as? NSArray else {
                return false
            }
            return array.contains { op.match($0) }
        }
    }
}

// everyValue - fact must pass operator for every element of value (array)
struct EveryValueDecorator: OperatorDecorator {
    static let id = DecoratorID(rawValue: "everyValue")

    static func decorate(_ makeOperator: OperatorFactory, value: AnyCodable) throws -> Operator {
        guard case .array(let valueArray) = value else {
            // Non-array values behave like the undecorated operator.
            return try makeOperator(value)
        }

        // Build the inner operator chain once per value element so validating
        // operators receive a single value, not the full value array.
        let operators: [Operator] = try valueArray.map { element in
            try makeOperator(AnyCodable(element))
        }

        return DecoratedOperator { objValue in
            operators.allSatisfy { $0.match(objValue) }
        }
    }
}

// someValue - fact must pass operator for at-least one element of value (array)
struct SomeValueDecorator: OperatorDecorator {
    static let id = DecoratorID(rawValue: "someValue")

    static func decorate(_ makeOperator: OperatorFactory, value: AnyCodable) throws -> Operator {
        guard case .array(let valueArray) = value else {
            // Non-array values behave like the undecorated operator.
            return try makeOperator(value)
        }

        // Build the inner operator chain once per value element so validating
        // operators receive a single value, not the full value array.
        let operators: [Operator] = try valueArray.map { element in
            try makeOperator(AnyCodable(element))
        }

        return DecoratedOperator { objValue in
            operators.contains { $0.match(objValue) }
        }
    }
}
