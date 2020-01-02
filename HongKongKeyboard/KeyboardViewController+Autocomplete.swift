import KeyboardKit
import UIKit

extension KeyboardViewController {
    func requestAutocompleteSuggestions() {
        let word = textDocumentProxy.currentWord ?? ""
        autocompleteProvider.autocompleteSuggestions(for: word) { [weak self] in
            self?.handleAutocompleteSuggestionsResult($0)
        }
    }

    func resetAutocompleteSuggestions() {
        autocompleteToolbar.reset()
    }
}

private extension KeyboardViewController {
    func handleAutocompleteSuggestionsResult(_ result: AutocompleteResult) {
        switch result {
        case let .failure(error): print(error.localizedDescription)
        case let .success(result): autocompleteToolbar.update(with: result)
        }
    }
}
