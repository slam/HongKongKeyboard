public class GoogleInputTools {

    private var input: String
    private var currentWord: String
    private var currentResponse: GoogleInputResponse?
    private var service: GoogleInputService

    public init() {
        self.input = String()
        self.currentWord = String()
        self.service = GoogleInputService()
    }

    public func append(_ char: String,
                       completion: ((String, String, GoogleInputResult) -> Void)?) {
        self.input.append(char)

        let thisInput = self.input
        let thisWord = self.currentWord
        self.service.send(currentWord: self.currentWord, input: self.input) { result in
            switch result {
            case .success(let response):
                self.currentResponse = response
            case .failure:
                break
            }
            completion?(thisWord, thisInput, result)
        }
    }

    @discardableResult
    public func popLast(_ completion: ((String, String, GoogleInputResult) -> Void)?) -> Character? {
        let char = input.popLast()

        let thisInput = self.input
        let thisWord = self.currentWord
        self.service.send(currentWord: self.currentWord, input: self.input) { result in
            switch result {
            case .success(let response):
                self.currentResponse = response
            case .failure:
                break
            }
            completion?(thisWord, thisInput, result)
        }
        return char
    }

    public func getInput() -> String {
        return self.input
    }
}
