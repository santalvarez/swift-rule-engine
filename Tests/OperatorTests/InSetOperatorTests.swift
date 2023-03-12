//
//  InSet.swift
//  SwiftRuleEngineTests
//
//  Created by Santiago Alvarez on 11/03/2023.
//

import XCTest

class InSet: XCTestCase {

//    func testListContainsPerformance() {
//        // Create a list of 2000 strings
//        var stringsList = [String]()
//        for i in 0..<500000 {
//            stringsList.append("string\(i)")
//        }
//
//        // Test the performance of list.contains
//        self.measure {
//            for i in 0..<1000 {
//                let stringToFind = "string\(i)"
//                let _ = stringsList.contains(stringToFind)
//            }
//        }
//    }
//
//    func testSetContainsPerformance() {
//        // Create a set of 2000 strings
//        var stringsSet = Set<String>()
//        for i in 0..<500000 {
//            stringsSet.insert("string\(i)")
//        }
//
//        // Test the performance of set.contains
//        self.measure {
//            for i in 0..<1000 {
//                let stringToFind = "string\(i)"
//                let _ = stringsSet.contains(stringToFind)
//            }
//        }
//    }
    let randomIndex = 99911912
    func testSearchTimeComplexity() {
        let numElements = 10000000
        let array = Array(0..<numElements)

        self.measure {
            _ = array.contains(randomIndex)
        }
    }

    func testSearchTimeComp() {
        let numElements = 10000000
        let array = Array(0..<numElements)
        let nsArray = NSArray(array: array)

        self.measure {
            nsArray.contains(randomIndex)
        }
    }
}
