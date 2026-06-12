//
//  OperatorDecorator.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 28/01/2026.
//

import Foundation


public protocol OperatorDecorator {
    static var id: DecoratorID { get }

    /// Wraps an operator and returns a new operator with modified behavior
    /// - Parameters:
    ///   - op: The operator instance to decorate
    ///   - operatorType: The original base operator type (needed for creating new instances)
    ///   - value: The value from the condition
    ///   - params: Optional parameters from the condition
    static func decorate(_ op: Operator, operatorType: Operator.Type, value: AnyCodable, params: [String: Any]?) -> Operator
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

    private let wrapped: Operator
    private let matchFunction: (Any) -> Bool

    init(wrapped: Operator, matchFunction: @escaping (Any) -> Bool) {
        self.wrapped = wrapped
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

    static func decorate(_ op: Operator, operatorType: Operator.Type, value: AnyCodable, params: [String: Any]?) -> Operator {
        DecoratedOperator(wrapped: op) { objValue in
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

    static func decorate(_ op: Operator, operatorType: Operator.Type, value: AnyCodable, params: [String: Any]?) -> Operator {
        DecoratedOperator(wrapped: op) { objValue in
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

    static func decorate(_ op: Operator, operatorType: Operator.Type, value: AnyCodable, params: [String: Any]?) -> Operator {
        // Need to create multiple operators, one for each value element
        guard case .array(let valueArray) = value else {
            // If value isn't an array, just return original operator
            return op
        }

        // Create operators for each value in the array using the original operator type
        let operators: [Operator] = valueArray.compactMap { element in
            try? operatorType.init(value: AnyCodable(element), params: params)
        }

        return DecoratedOperator(wrapped: op) { objValue in
            operators.allSatisfy { $0.match(objValue) }
        }
    }
}

// someValue - fact must pass operator for at-least one element of value (array)
struct SomeValueDecorator: OperatorDecorator {
    static let id = DecoratorID(rawValue: "someValue")

    static func decorate(_ op: Operator, operatorType: Operator.Type, value: AnyCodable, params: [String: Any]?) -> Operator {
        guard case .array(let valueArray) = value else {
            return op
        }

        // Create operators for each value in the array using the original operator type
        let operators: [Operator] = valueArray.compactMap { element in
            try? operatorType.init(value: AnyCodable(element), params: params)
        }

        return DecoratedOperator(wrapped: op) { objValue in
            operators.contains { $0.match(objValue) }
        }
    }
}
