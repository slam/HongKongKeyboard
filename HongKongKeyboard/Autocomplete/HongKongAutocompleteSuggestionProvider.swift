import KeyboardKit

/**
 This autocomplete suggestion provider just returns the
 current word suffixed with "ly", "er" and "ter".
 */
class HongKongAutocompleteSuggestionProvider: AutocompleteSuggestionProvider {
    func autocompleteSuggestions(for text: String, completion: AutocompleteResponse) {
        guard text.count > 0 else { return completion(.success([])) }
        let suffixes = ["ly", "er", "ter"]
        let suggestions = suffixes.map { text + $0 }
        completion(.success(suggestions))
    }

    @available(*, deprecated, renamed: "autocompleteSuggestions(for:completion:)")
    func provideAutocompleteSuggestions(for text: String, completion: AutocompleteResponse) {
        autocompleteSuggestions(for: text, completion: completion)
    }
}
