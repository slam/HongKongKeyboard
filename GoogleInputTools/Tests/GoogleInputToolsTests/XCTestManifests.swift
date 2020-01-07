import XCTest

#if !canImport(ObjectiveC)
    public func allTests() -> [XCTestCaseEntry] {
        [
            testCase(GoogleInputToolsTests.allTests),
        ]
    }
#endif
