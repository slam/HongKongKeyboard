public class GoogleInputTools {
    public private(set) var input: String
    public private(set) var currentWord: String
    public private(set) var currentResponse: GoogleInputResponse?
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
        guard let char = input.popLast() else {
            return nil
        }

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

    public func pickSuggestion(_ index: Int) -> String? {
        guard let response = currentResponse else {
            return nil
        }
        guard response.status == GoogleInputResponse.Status.success else {
            return nil
        }
        guard response.suggestions.count > index else {
            return nil
        }

        let word = response.suggestions[index].word
        let length = response.suggestions[index].matchedLength
        currentResponse = nil
        input = String(input.dropFirst(length))
        return word
    }
}
