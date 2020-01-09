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
        requestSuggestions()
    }

    override func selectionWillChange(_ textInput: UITextInput?) {
        print("selectionWillChange")
        super.selectionWillChange(textInput)
        suggestionToolbar.reset()
    }

    override func selectionDidChange(_ textInput: UITextInput?) {
        print("selectionDidChange")
        super.selectionDidChange(textInput)
        suggestionToolbar.reset()
    }

    // MARK: - Properties

    let alerter = ToastAlert()

    var inputTools = GoogleInputTools()

    var keyboardType = KeyboardType.alphabetic(uppercased: false) {
        didSet { setupKeyboard() }
    }

    lazy var suggestionToolbar: SuggestionToolbar = {
        SuggestionToolbar {
            SuggestionLabel(suggestion: $0,
                            proxy: self.textDocumentProxy,
                            inputTools: self.inputTools,
                            keyboardViewController: self)
        }
    }()
}
