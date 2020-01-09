import GoogleInputTools
import KeyboardKit
import UIKit

extension KeyboardViewController {
    func requestSuggestions() {
        let word = textDocumentProxy.currentWord ?? ""
        print("requestSuggestions word=\(word)")
        inputTools.updateCurrentWord(word) { [weak self] _, _, result in
            switch result {
            case let .success(response):
                guard response.status == GoogleInputResponse.Status.success else {
                    print(response.status.rawValue)
                    return
                }
                var count = 0
                var suggestions = [GoogleInputSuggestion]()
                for suggestion in response.suggestions {
                    count += suggestion.word.count
                    if count < 15 {
                        suggestions.append(suggestion)
                    }
                }
                DispatchQueue.main.async {
                    self?.handleSuggestionsResult(.success(suggestions))
                }
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }

    func resetAutocompleteSuggestions() {
        suggestionToolbar.reset()
    }
}

private extension KeyboardViewController {
    func handleSuggestionsResult(_ result: Result<[GoogleInputSuggestion], Error>) {
        switch result {
        case let .failure(error): print(error.localizedDescription)
        case let .success(result): suggestionToolbar.update(with: result)
        }
    }
}
