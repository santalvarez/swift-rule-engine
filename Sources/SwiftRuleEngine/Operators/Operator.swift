//
//  Operator.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 21/12/2022.
//

import Foundation


public protocol Operator {
    static var id: OperatorID { get }

    init(value: AnyCodable, params: [String : Any]?) throws

    func match(_ objValue: Any) -> Bool
}


public struct OperatorID: RawRepresentable, Hashable, Equatable, Decodable, Sendable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}


enum OperatorError: Error, CustomStringConvertible {
    case invalidValueType
    case invalidValue

    var description: String {
        switch self {
        case .invalidValueType:
            return "Invalid value type"
        case .invalidValue:
            return "Invalid value"
        }
    }
}
