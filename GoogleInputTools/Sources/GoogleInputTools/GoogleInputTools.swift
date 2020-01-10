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
        service.send(currentWord: currentWord, input: input) { [weak self] result in
            switch result {
            case let .success(response):
                guard thisInput == self?.input else {
                    print("Response was late for input \"\(thisInput)\". Discarding...")
                    return
                }
                self?.currentResponse = response
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
        service.send(currentWord: currentWord, input: input) { [weak self] result in
            switch result {
            case let .success(response):
                guard thisInput == self?.input else {
                    print("Response was late for input \"\(thisInput)\". Discarding...")
                    return
                }
                self?.currentResponse = response
            case .failure:
                break
            }
            completion?(thisWord, thisInput, result)
        }
        return char
    }

    public func updateCurrentWord(_ currentWord: String,
                                  completion: ((String, String, GoogleInputResult) -> Void)? = nil) {
        self.currentWord = currentWord
        guard input.count > 0 else {
            completion?(currentWord, input, .success(GoogleInputResponse()))
            return
        }

        let thisInput = input
        let thisWord = self.currentWord
        service.send(currentWord: currentWord, input: input) { [weak self] result in
            switch result {
            case let .success(response):
                guard thisInput == self?.input else {
                    print("Response was late for input \"\(thisInput)\". Discarding...")
                    return
                }
                self?.currentResponse = response
            case .failure:
                break
            }
            completion?(thisWord, thisInput, result)
        }
    }

    public func pickSuggestion(_ suggestion: GoogleInputSuggestion) -> String {
        let word = suggestion.word
        let length = suggestion.matchedLength
        currentResponse = nil
        input = String(input.dropFirst(length))
        return word
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

        return pickSuggestion(response.suggestions[index])
    }

    public func reset() {
        input = ""
        currentWord = ""
        currentResponse = nil
    }
}
