//
//  SimpleCondition.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 17/09/2023.
//

import Foundation


public struct SimpleCondition: Condition {
    public var match: Bool = false
    public let op: [Operator]  // operator kw is reserved
    public let value: AnyCodable
    public let params: [String: Any]?
    public let path: JSONPath?

    private let mode: Mode?

    public mutating func evaluate(_ obj: Any) throws {
        guard let mode = self.mode else {
            if let path = self.path {
                let obj = try path.getValue(for: obj)
                self.match = op.first!.match(obj)
                return
            }
            self.match = op.first!.match(obj)
            return
        }

        guard let path = self.path else {
            self.match = op.first!.match(obj)
            return
        }

        let obj = try path.getValue(for: obj)

        switch mode {
        case .any:
            self.match = op.contains { $0.match(obj) }
        case .all:
            self.match = op.allSatisfy { $0.match(obj) }
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.params = try? container.decode([String: Any].self, forKey: .params)
        self.value =  try container.decode(AnyCodable.self, forKey: .value)
        if let modeStr = self.params?["mode"] as? String {
            self.mode = Mode(rawValue: modeStr)
            if self.mode == nil {
                throw DecodingError.dataCorruptedError(forKey: .params, in: container,
                                                       debugDescription: "Invalid mode value")
            }
            // If mode is set then the value has to be an array
            if case .array(_) = value {} else {
                throw DecodingError.dataCorruptedError(forKey: .value, in: container,
                                                       debugDescription: "Value should be an array when mode is specified")
            }
        } else {
            self.mode = nil
        }

        let operatorID = try container.decode(OperatorID.self, forKey: .op)
        guard let operatorsDict = decoder.userInfo[operatorsUserInfoKey] as? [OperatorID: Operator.Type] else {
            throw DecodingError.dataCorruptedError(forKey: .op, in: container, debugDescription: "Operators user info key not provided")
        }
        guard let operatorType = operatorsDict[operatorID] else {
            throw DecodingError.dataCorruptedError(forKey: .op, in: container, debugDescription: "Operator \(operatorID.rawValue) not found")
        }

        do {
            if self.mode == nil {
                self.op = [try operatorType.init(value: self.value, params: self.params)]
            } else {
                // Iterate value and initialize all operators
                var ops: [Operator] = []
                for v in self.value.value() as! [Any] {
                    ops.append(try operatorType.init(value: AnyCodable(v), params: self.params))
                }
                self.op = ops
            }
        } catch {
            throw DecodingError.dataCorruptedError(forKey: .op, in: container, debugDescription: "Error initializing operator \(operatorID.rawValue)")
        }

        guard let pathStr = try container.decodeIfPresent(String.self, forKey: .path) else {
            self.path = nil
            return
        }
        self.path = try JSONPath(pathStr)
    }

    private enum CodingKeys: String, CodingKey {
        case op = "operator", value, params, path
    }

    private enum Mode: String {
        case any
        case all
    }
}
