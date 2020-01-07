import GoogleInputTools
import Nimble
import Quick

class GoogleInputToolsTests: QuickSpec {
    override func spec() {
        describe("example") {
            var inputTools: GoogleInputTools!

            beforeEach {
                inputTools = GoogleInputTools()
            }

            it("can append and remove characters") {
                inputTools.append("a")
                expect(inputTools.getInput()).to(equal("a"))
                inputTools.append("b")
                expect(inputTools.getInput()).to(equal("ab"))
                inputTools.append("c")
                expect(inputTools.getInput()).to(equal("abc"))
                inputTools.popLast()
                expect(inputTools.getInput()).to(equal("ab"))
                inputTools.popLast()
                expect(inputTools.getInput()).to(equal("a"))
                inputTools.popLast()
                expect(inputTools.getInput()).to(equal(""))
                inputTools.popLast()
                expect(inputTools.getInput()).to(equal(""))
            }
        }
    }
}
