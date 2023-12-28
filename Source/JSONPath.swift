//
//  JSONPath.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 20/02/2023.
//

import Foundation
// import SwiftPath

enum JSONPathError: Error {
    case valueNotFound
    case invalidPath
    case expectingDictionary
}


public struct JSONPath {
   let components: [String]

   init(_ path: String) throws {
       if !path.starts(with: "$.") {
           throw JSONPathError.invalidPath
       }

       self.components = path.dropFirst(2).components(separatedBy: ".")
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

   func getValue(for obj: Any) throws -> Any {
       var currentObj: Any = obj

       for component in self.components {
           guard let dict = currentObj as? [String: Any] else {
               throw JSONPathError.expectingDictionary
           }
           currentObj = try self.accessDict(component, dict)
       }

       return currentObj

   }
}

// public struct JSONPath {
//     let path: JsonPath

//     init(_ path: String) throws {
//         guard let jp = JsonPath(path) else {
//             throw JSONPathError.invalidPath
//         }
//         self.path = jp
//     }

//     func getValue(for obj: Any) throws -> Any {
//         do {
//             return try self.path.evaluate(with: obj) as Any
//         } catch {
//             throw JSONPathError.valueNotFound
//         }
//     }
// }

