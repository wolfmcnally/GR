import XCTest
@testable import GR

final class GRTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(GR().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
