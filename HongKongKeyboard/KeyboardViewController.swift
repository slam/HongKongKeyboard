import GoogleInputTools
import KeyboardKit
import UIKit

// - add branding to the empty autocomplete area
// - remove symbol input set for zh

class KeyboardViewController: KeyboardInputViewController {
    override func viewDidLoad() {
        KKL10n.bundle = Bundle.main

        keyboardContext.locale = Locale(identifier: "zh")
        keyboardContext.locales = [Locale(identifier: "en"), Locale(identifier: "zh")]

        autocompleteProvider = KeyboardAutocompleteProvider(context: keyboardContext,
                                                            inputToolsContext: inputToolsContext)

        inputSetProvider = StandardInputSetProvider(context: keyboardContext,
                                                    providers: [InputToolsInputSetProvider(),
                                                                EnglishInputSetProvider()])

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
