//
//  Operator.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 21/12/2022.
//

import Foundation


public protocol Operator {
    var id: OperatorID { get }

    func match(_ condition: SimpleCondition, _ objValue: Any) -> Bool
}


public struct OperatorID: RawRepresentable, Hashable, Equatable, Decodable {
    public var rawValue: String

    public static let equal = OperatorID(rawValue: "equal")
    public static let not_equal = OperatorID(rawValue: "not_equal")
    public static let less_than = OperatorID(rawValue: "less_than")
    public static let less_than_inclusive = OperatorID(rawValue: "less_than_inclusive")
    public static let greater_than = OperatorID(rawValue: "greater_than")
    public static let greater_than_inclusive = OperatorID(rawValue: "greater_than_inclusive")
    public static let in_ = OperatorID(rawValue: "in")
    public static let not_in = OperatorID(rawValue: "not_in")
    public static let contains = OperatorID(rawValue: "contains")
    public static let not_contains = OperatorID(rawValue: "not_contains")
    public static let regex = OperatorID(rawValue: "regex")
    public static let in_set = OperatorID(rawValue: "in_set")
    public static let not_in_set = OperatorID(rawValue: "in_set")

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}
