import Foundation
import GoogleInputTools
import KeyboardKit

enum GoogleInputToolsError: Error {
    case badStatus(status: String)
}

class KeyboardAutocompleteProvider: AutocompleteProvider {
    init(context: KeyboardContext, inputToolsContext: InputToolsContext) {
        self.context = context
        self.inputToolsContext = inputToolsContext
        inputService = GoogleInputService()
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
        print("fetchGoogleInputToolsSuggestions text=\(text) currentWord=\(currentWord)")
        inputService.send(currentWord: currentWord, input: text) { result in
            switch result {
            case let .success(response):
                if response.status != GoogleInputResponse.Status.success {
                    print(response.status.rawValue)
                    completion(.failure(GoogleInputToolsError.badStatus(status: response.status.rawValue)))
                    return
                }
                let firstSuggestion = response.suggestions.count > 0 ? response.suggestions[0].word : ""
                let message = "currentWord=\(currentWord) input=\(text) suggestion=\(firstSuggestion)"
                print(message)
                completion(.success(
                    response.suggestions.prefix(5).map {
                        StandardAutocompleteSuggestion(text: $0.word,
                                                       subtitle: $0.annotation,
                                                       additionalInfo: ["suggestion": $0])
                    }))
                return
            case let .failure(error):
                let message = "currentWord=\(currentWord) input=\(text) error=\(error.localizedDescription)"
                print(message)
                completion(.failure(error))
                return
            }
        }
    }
}
