import XCTest
@testable import SwiftPackageWordLookup

final class SwiftPackageWordLookupTests: XCTestCase {
    // TODO: Use DI to aboid real network call.
    func testLookupWord() {
        let lookup = SwiftPackageWordLookup(appKey: "xxxx",
                                            appID: "xxxx")
        // Create an expectation
        let expectation = self.expectation(description: "Lookup")
        lookup.lookupWord(word: "contemplate") { (meaning:String?, error:Error?) in
            guard error == nil else {
                XCTAssert(false, "Word lookup failed!")
                expectation.fulfill()
                return
            }
            print("Meaning: \(meaning!)")
            XCTAssert(true, "Word lookup is Successful!")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 45)
    }

    static var allTests = [
        ("testExample", testLookupWord),
    ]
}
