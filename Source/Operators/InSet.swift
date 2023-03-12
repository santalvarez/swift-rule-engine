//
//  InSet.swift
//  SwiftRuleEngine
//
//  Created by Santiago Alvarez on 11/03/2023.
//

import Foundation


//struct InSet: Operator {
//    let id = "in_set"
//    private var cache = NSCache<NSString, NSSet>()
//
//    private func getSet(_ condition: SimpleCondition) -> NSSet? {
//        if let set = cache.object(forKey: <#T##NSString#>) {
//            return set
//        }
//
//        guard let newSet = condition.value.value as? NSSet else {
//            return nil
//        }
//
//        cache.setObject(newSet, forKey: <#T##NSString#>)
//        return newSet
//    }
//
//    func match(_ condition: SimpleCondition, _ objValue: Any) -> Bool {
//        switch condition.value.valueType {
//        case .array:
//            guard let lhs = self.getSet(condition) else {
//                return false
//            }
//            return lhs.contains(objValue)
//
//        default:
//            return false
//        }
//    }
//}
