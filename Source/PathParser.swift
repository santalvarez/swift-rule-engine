//
//  PathParser.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 20/02/2023.
//

import Foundation


enum PathParserError: Error {
    case valueNotFound
    case invalidPath
    case expectingDictionary
}


struct PathParser {
    
    private func accessDict(_ key: String, _ dict: [String: Any]) throws -> Any {
        if let value = dict[key] {
            return value
        } else if dict[key] == nil {
            return NSNull()
        } else {
            throw PathParserError.valueNotFound
        }
    }

    func getValue(_ path: String, _ obj: Any) throws -> Any {
        if !path.starts(with: "$.") {
            throw PathParserError.invalidPath
        }

        let path = path.replacingOccurrences(of: "$.", with: "")
        let pathComponents = path.components(separatedBy: ".")

        var currentObj: Any = obj

        for component in pathComponents {
            guard let dict = currentObj as? [String: Any] else {
                throw PathParserError.expectingDictionary
            }
            currentObj = try self.accessDict(component, dict)
        }

        return currentObj
    }

}
