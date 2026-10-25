import XCTest
@testable import SwiftRuleEngine

@StringSubscriptable
struct GeneratedLookup {
    let firstName: String
    let optionalName: String?
    let count: Int
    private let hidden = 99
    static let shared = 100

    var doubledCount: Int { count * 2 }
}

@StringSubscriptable
struct KeywordLookup {
    let `class` = 42
}

@StringSubscriptable
struct EmptyLookup {}

@StringSubscriptable
struct AcronymLookup {
    let URLValue = "https://example.com"
    let teamID = "TEAM"
}

final class StringSubscriptableSwitchTests: XCTestCase {
    func testGeneratedKeysAndComputedProperty() {
        let object = GeneratedLookup(firstName: "Ada", optionalName: "Lovelace", count: 3)

        XCTAssertEqual(object["first_name"] as? String, "Ada")
        XCTAssertEqual(object["optional_name"] as? String, "Lovelace")
        XCTAssertEqual(object["doubled_count"] as? Int, 6)
        XCTAssertNil(object["firstName"])
        XCTAssertNil(object["hidden"])
        XCTAssertNil(object["shared"])
        XCTAssertNil(object["missing"])
    }

    func testNilOptionalRemainsBoxed() {
        let generated = GeneratedLookup(firstName: "Ada", optionalName: nil, count: 3)

        XCTAssertNotNil(generated["optional_name"])
        XCTAssertNil(generated["optional_name"] as? String)
    }

    func testKeywordAndEmptyTypes() {
        XCTAssertEqual(KeywordLookup()["class"] as? Int, 42)
        XCTAssertNil(EmptyLookup()["anything"])
    }

    func testAcronymKeys() {
        let object = AcronymLookup()

        XCTAssertEqual(object["url_value"] as? String, "https://example.com")
        XCTAssertEqual(object["team_id"] as? String, "TEAM")
        XCTAssertNil(object["urlvalue"])
    }
}
