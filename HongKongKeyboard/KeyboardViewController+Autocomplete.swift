import GoogleInputTools
import KeyboardKit
import UIKit

extension KeyboardViewController {
    func requestAutocompleteSuggestions() {
        let word = textDocumentProxy.currentWord ?? ""
        print("requestAutocompleteSuggestions word=\(word)")
        inputTools.updateCurrentWord(word) { [weak self] _, _, result in
            switch result {
            case let .success(response):
                guard response.status == GoogleInputResponse.Status.success else {
                    print(response.status.rawValue)
                    return
                }
                var count = 0
                var words = [String]()
                for suggestion in response.suggestions {
                    count += suggestion.word.count
                    if count < 15 {
                        words.append(suggestion.word)
                    }
                }
                DispatchQueue.main.async {
                    self?.handleAutocompleteSuggestionsResult(.success(words))
                }
            case let .failure(error):
                print(error.localizedDescription)
            }
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
