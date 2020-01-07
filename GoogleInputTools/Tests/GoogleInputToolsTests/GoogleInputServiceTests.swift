import Foundation
@testable import GoogleInputTools
import Nimble
import Quick

class GoogleInputServiceTests: QuickSpec {
    override func spec() {
        describe("GoogleInputService") {
            // Disable because waitUntil doesn't work: https://github.com/Quick/Nimble/issues/509
            xit("can send single character") {
                let service = GoogleInputService()

                waitUntil { done in
                    service.send(currentWord: "", input: "a") { result in
                        switch result {
                        case let .success(response):
                            expect(response).toNot(beNil())
                            expect(response.status).to(equal(GoogleInputResponse.Status.success))
                            expect(response.input).to(equal("a"))
                            expect(response.suggestions).to(haveCount(13))
                        case let .failure(error):
                            expect(error).to(beNil())
                        }
                        done()
                    }
                }
            }
        }
    }
}
