import GoogleInputTools
import KeyboardKit
import UIKit

// TODO
//
// - custom keyboard layout, with chinese punctuations, space bar text and '
// - add back horizontal scroll to the autocomplete toolbar
// - update main app look and feel, add check for full access

class KeyboardViewController: KeyboardInputViewController {
    override func viewDidLoad() {
        autocompleteProvider = KeyboardAutocompleteProvider(context: keyboardContext, inputToolsContext: inputToolsContext)
        keyboardActionHandler = InputToolsActionHandler(inputViewController: self, inputToolsContext: inputToolsContext)
        super.viewDidLoad()
    }

    override func viewWillSetupKeyboard() {
        super.viewWillSetupKeyboard()

        setup(with: KeyboardView().environmentObject(inputToolsContext))
    }

    override func performAutocomplete() {
        if inputToolsContext.input == "" {
            resetAutocomplete()
            return
        }

        autocompleteProvider.autocompleteSuggestions(for: inputToolsContext.input) { [weak self] result in
            DispatchQueue.main.async { [weak self] in
                guard let context = self?.autocompleteContext else { return }
                switch result {
                case let .failure(error):
                    context.lastError = error
                case let .success(result):
                    context.suggestions = result
                    context.lastError = nil
                }
            }
        }
    }

    private lazy var inputToolsContext = InputToolsContext()
}
