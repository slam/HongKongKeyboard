import Foundation
import GoogleInputTools
import KeyboardKit

enum GoogleInputToolsError: Error {
    case parsingError(status: String)
    case lateArriving(input: String)
}

class KeyboardAutocompleteProvider: AutocompleteProvider {
    init(context: KeyboardContext, inputToolsContext: InputToolsContext) {
        self.context = context
        self.inputToolsContext = inputToolsContext
        inputService = GoogleInputService(app: "粵語拼音", num: 100)
    }

    private let context: KeyboardContext
    private let inputToolsContext: InputToolsContext
    private let inputService: GoogleInputService

    var locale: Locale = .current

    var canIgnoreWords: Bool { false }
    var canLearnWords: Bool { false }
    var ignoredWords: [String] = []
    var learnedWords: [String] = []

    func hasIgnoredWord(_: String) -> Bool { false }
    func hasLearnedWord(_: String) -> Bool { false }
    func ignoreWord(_: String) {}
    func learnWord(_: String) {}
    func removeIgnoredWord(_: String) {}
    func unlearnWord(_: String) {}

    func autocompleteSuggestions(for text: String, completion: @escaping AutocompleteCompletion) {
        guard text.count > 0 else { return completion(.success([])) }
        fetchGoogleInputToolsSuggestions(for: text, completion: completion)
    }
}

private extension KeyboardAutocompleteProvider {
    func fetchGoogleInputToolsSuggestions(for text: String, completion: @escaping AutocompleteCompletion) {
        let currentWord = context.textDocumentProxy.currentWord ?? ""
        #if DEBUG
            print("fetchGoogleInputToolsSuggestions text=\(text) currentWord=\(currentWord)")
        #endif
        inputService.send(currentWord: currentWord, input: text) { [weak self] result in
            switch result {
            case let .success(response):
                guard response.status == GoogleInputResponse.Status.success else {
                    #if DEBUG
                        print(response.status.rawValue)
                    #endif
                    completion(.failure(GoogleInputToolsError.parsingError(status: response.status.rawValue)))
                    return
                }
                guard text == self?.inputToolsContext.input else {
                    #if DEBUG
                        let message = "Response was late for \"\(text)\". Discarding..."
                        print(message)
                    #endif
                    completion(.failure(GoogleInputToolsError.lateArriving(input: text)))
                    return
                }
                let firstSuggestion = response.suggestions.count > 0 ? response.suggestions[0].word : ""
                #if DEBUG
                    let message = "currentWord=\(currentWord) input=\(text) suggestion=\(firstSuggestion)"
                    print(message)
                #endif
                completion(.success(
                    response.suggestions.map {
                        StandardAutocompleteSuggestion(text: $0.word,
                                                       subtitle: $0.annotation,
                                                       additionalInfo: ["suggestion": $0])
                    }))
                return
            case let .failure(error):
                #if DEBUG
                    let message = "currentWord=\(currentWord) input=\(text) error=\(error.localizedDescription)"
                    print(message)
                #endif
                completion(.failure(error))
                return
            }
        }
    }
}

extension GoogleInputToolsError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case let .parsingError(status):
            let format = NSLocalizedString("Google Input Tools returned '%@'", comment: "")
            return String(format: format, status)
        case let .lateArriving(input):
            let format = NSLocalizedString("Response was late for '%@'", comment: "")
            return String(format: format, input)
        }
    }
}
