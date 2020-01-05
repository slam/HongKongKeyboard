import Alamofire

public class GoogleInputTools {

    var input: String

    public init() {
        self.input = String()
    }

    public func append(_ string: String) {
        input.append(string)
    }

    @discardableResult
    public func popLast() -> Character? {
        return input.popLast()
    }

    public func getInput() -> String {
        return self.input
    }

    public func getText() -> String {
        return "Hello, World!"
    }
}
