import GoogleInputTools
import KeyboardKit
import UIKit

extension KeyboardViewController {
    func requestSuggestions() {
        let word = textDocumentProxy.currentWord ?? ""
        print("requestSuggestions word=\(word) count=\(word.count)")
        inputTools.updateCurrentWord(word) { [weak self] _, input, result in
            switch result {
            case let .success(response):
                guard response.status == GoogleInputResponse.Status.success else {
                    print(response.status.rawValue)
                    return
                }
                DispatchQueue.main.async {
                    self?.updateSpacebarText(input)
                    self?.handleSuggestionsResult(.success(response.suggestions))
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
