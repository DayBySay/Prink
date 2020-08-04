import XCTest
@testable import Prink

final class PrinkTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Prink().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
