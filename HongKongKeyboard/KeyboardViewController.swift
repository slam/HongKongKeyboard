import GoogleInputTools
import KeyboardKit
import UIKit

// - new punctation layout only for zh locale
// - update main app look and feel, add check for full access
// - add haptic and audio feedback?

class KeyboardViewController: KeyboardInputViewController {
    override func viewDidLoad() {
        KKL10n.bundle = Bundle.main

        keyboardContext.locale = Locale(identifier: "zh")
        keyboardContext.locales = [Locale(identifier: "en"), Locale(identifier: "zh")]

        autocompleteProvider = KeyboardAutocompleteProvider(context: keyboardContext,
                                                            inputToolsContext: inputToolsContext)

        inputSetProvider = InputToolsInputSetProvider()

        keyboardAppearance = InputToolsAppearance(context: keyboardContext)

        keyboardLayoutProvider = InputToolsLayoutProvider(
            inputSetProvider: inputSetProvider,
            dictationReplacement: .custom(named: "中")
        )

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
