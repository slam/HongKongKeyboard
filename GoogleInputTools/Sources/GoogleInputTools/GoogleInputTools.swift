public class GoogleInputTools {
    private var input: String
    private var currentWord: String
    private var currentResponse: GoogleInputResponse?
    private var service: GoogleInputService

    public init() {
        input = String()
        currentWord = String()
        service = GoogleInputService()
    }

    public func append(_ char: String,
                       completion: ((String, String, GoogleInputResult) -> Void)? = nil) {
        input.append(char)

        let thisInput = input
        let thisWord = currentWord
        service.send(currentWord: currentWord, input: input) { result in
            switch result {
            case let .success(response):
                self.currentResponse = response
            case .failure:
                break
            }
            completion?(thisWord, thisInput, result)
        }
    }

    @discardableResult
    public func popLast(_ completion: ((String, String, GoogleInputResult) -> Void)? = nil) -> Character? {
        let char = input.popLast()

        let thisInput = input
        let thisWord = currentWord
        service.send(currentWord: currentWord, input: input) { result in
            switch result {
            case let .success(response):
                self.currentResponse = response
            case .failure:
                break
            }
            completion?(thisWord, thisInput, result)
        }
        return char
    }

    public func getInput() -> String {
        input
    }
}
