import KeyboardKit
import UIKit

class KeyboardViewController: KeyboardInputViewController {
    // MARK: - View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardActionHandler = HongKongKeyboardActionHandler(inputViewController: self)
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
        super.textDidChange(textInput)
        requestAutocompleteSuggestions()
    }

    override func selectionWillChange(_ textInput: UITextInput?) {
        super.selectionWillChange(textInput)
        autocompleteToolbar.reset()
    }

    override func selectionDidChange(_ textInput: UITextInput?) {
        super.selectionDidChange(textInput)
        autocompleteToolbar.reset()
    }

    // MARK: - Properties

    let alerter = ToastAlert()

    var keyboardType = KeyboardType.alphabetic(uppercased: false) {
        didSet { setupKeyboard() }
    }

    // MARK: - Autocomplete

    lazy var autocompleteProvider = HongKongAutocompleteSuggestionProvider()

    lazy var autocompleteToolbar: AutocompleteToolbar = {
        AutocompleteToolbar(textDocumentProxy: textDocumentProxy)
    }()
}
