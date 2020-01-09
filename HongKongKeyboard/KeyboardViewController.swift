import GoogleInputTools
import KeyboardKit
import UIKit

class KeyboardViewController: KeyboardInputViewController {
    // MARK: - View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardActionHandler = HongKongKeyboardActionHandler(inputViewController: self,
                                                              googleInputTools: inputTools)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupKeyboard()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        setupKeyboard(for: size)
    }

    // MARK: - Keyboard Functionality

    override func textDidChange(_ textInput: UITextInput?) {
        print("textDidChange")
        super.textDidChange(textInput)
        requestAutocompleteSuggestions()
    }

    override func selectionWillChange(_ textInput: UITextInput?) {
        print("selectionWillChange")
        super.selectionWillChange(textInput)
        autocompleteToolbar.reset()
    }

    override func selectionDidChange(_ textInput: UITextInput?) {
        print("selectionDidChange")
        super.selectionDidChange(textInput)
        autocompleteToolbar.reset()
    }

    // MARK: - Properties

    let alerter = ToastAlert()

    var keyboardType = KeyboardType.alphabetic(uppercased: false) {
        didSet { setupKeyboard() }
    }

    var inputTools = GoogleInputTools()

    // MARK: - Autocomplete

    lazy var autocompleteProvider = HongKongAutocompleteSuggestionProvider()

    lazy var autocompleteToolbar: AutocompleteToolbar = {
        AutocompleteToolbar(height: .standardKeyboardRowHeight,
                            buttonCreator: { HongKongAutocompleteLabel(word: $0, proxy: self.textDocumentProxy) },
                            alignment: .fill,
                            distribution: .fillProportionally)
    }()
}
