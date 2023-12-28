//
//  JSONPath.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 20/02/2023.
//

import Foundation

enum JSONPathError: Error {
    case valueNotFound
    case invalidPath
    case expectingDictionary
}

enum JSONPart {
    case key(String)
    case index(Int)
}


public struct JSONPath {
    private let parts: [JSONPart]
    private let pathRegex = try! NSRegularExpression(pattern: #"\$\.((\w+\[\d+\](\.|$)|(\w+\.)))*(\w+\[\d+\]|\w+)$"#)

    init(_ path: String) throws {
        guard path != "$" else {
            self.parts = []
            return
        }

        guard pathRegex.firstMatch(in: path, options: [],
                                   range: NSRange(location: 0, length: path.count)) != nil else {
            throw JSONPathError.invalidPath
        }

        self.parts = try path.components(separatedBy: ".").dropFirst().map { char in
            if char.hasPrefix("[") && char.hasSuffix("]") {
                guard let index = Int(char.dropFirst().dropLast()) else {
                    throw JSONPathError.invalidPath
                }
                return .index(index)
            } else {
                return .key(char)
            }
        }
    }

    private func accessDict(_ key: String, _ dict: [String: Any]) throws -> Any {
        if let value = dict[key] {
            return value
        } else if dict[key] == nil {
            return NSNull()
        } else {
            throw JSONPathError.valueNotFound
        }
    }

    private func accessArray(_ index: Int, _ array: [Any]) throws -> Any {
        if index < array.count {
            return array[index]
        } else {
            throw JSONPathError.valueNotFound
        }
    }

    func getValue(for obj: Any) throws -> Any {
        var currentObj: Any = obj

        for p in self.parts {
            switch p {
            case .key(let key):
                guard let dict = currentObj as? [String: Any] else {
                    throw JSONPathError.expectingDictionary
                }
                currentObj = try self.accessDict(key, dict)
            case .index(let index):
                guard let array = currentObj as? [Any] else {
                    throw JSONPathError.expectingDictionary
                }
                currentObj = try self.accessArray(index, array)
            }
        }
        return currentObj
    }
}
