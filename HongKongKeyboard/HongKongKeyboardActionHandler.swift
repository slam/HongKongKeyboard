import KeyboardKit
import GoogleInputTools
import UIKit

class HongKongKeyboardActionHandler: StandardKeyboardActionHandler {
    var inputTools: GoogleInputTools

    // MARK: - Initialization

    public init(inputViewController: UIInputViewController) {
        keyboardShiftState = .lowercased
        inputTools = GoogleInputTools()
        super.init(
            inputViewController: inputViewController,
            hapticConfiguration: .standard
        )
    }

    // MARK: - Properties

    private var keyboardShiftState: KeyboardShiftState

    private var keyboardViewController: KeyboardViewController? {
        inputViewController as? KeyboardViewController
    }

    // MARK: - Actions

    override func longPressAction(for action: KeyboardAction, view: UIView) -> GestureAction? {
        switch action {
        case .shift: return switchToCapsLockedKeyboard
        default: return super.longPressAction(for: action, view: view)
        }
    }

    override func tapAction(for action: KeyboardAction, view: UIView) -> GestureAction? {
        switch action {
        case .character: return handleCharacter(action, for: view)
        case .shift: return switchToUppercaseKeyboard
        case .shiftDown: return switchToLowercaseKeyboard
        case .space: return handleSpace(for: view)
        case .backspace: return handleBackspace(for: view)
        case let .switchToKeyboard(type): return { [weak self] in self?.keyboardViewController?.keyboardType = type }
        default: return super.tapAction(for: action, view: view)
        }
    }

    // MARK: - Action Handling

    override func handle(_ gesture: KeyboardGesture, on action: KeyboardAction, view: UIView) {
        super.handle(gesture, on: action, view: view)
        keyboardViewController?.requestAutocompleteSuggestions()
    }
}

// MARK: - Actions

private extension HongKongKeyboardActionHandler {
    func alert(_ message: String) {
        guard let input = inputViewController as? KeyboardViewController else { return }
        input.alerter.alert(message: message, in: input.view, withDuration: 4)
    }

    func updateToolbar(_ response: GoogleInputResponse) {
        guard let input = inputViewController as? KeyboardViewController else { return }

        var count = 0
        var words = [String]()
        for suggestion in response.suggestions {
            count += suggestion.word.count
            if count < 15 {
                words.append(suggestion.word)
            }
        }
        input.autocompleteToolbar.update(with: words)
    }

    func handleGoogleInputResult(currentWord: String, input: String, result: GoogleInputResult) {
        switch result {
        case .success(let response):
            if response.status != GoogleInputResponse.Status.success {
                DispatchQueue.main.async {
                    self.alert(response.status.rawValue)
                }
                return
            }
            let firstSuggestion = response.suggestions.count > 0 ? response.suggestions[0].word : ""
            let message = "currentWord=\(currentWord) input=\(input) suggestion=\(firstSuggestion)"
            print(message)
            DispatchQueue.main.async {
                self.updateToolbar(response)
            }
        case .failure(let error):
            DispatchQueue.main.async {
                self.alert(error.localizedDescription)
            }
        }
    }

    func handleCharacter(_ action: KeyboardAction, for view: UIView) -> GestureAction {
        return { [weak self] in
            switch action {
            case .character(let char):
                self?.inputTools.append(char) { currentWord, input, result in
                    self?.handleGoogleInputResult(currentWord: currentWord, input: input, result: result)
                }
            default: return
            }
        }
    }

    func handleSpace(for view: UIView) -> GestureAction {
        let baseAction = super.tapAction(for: .space, view: view)
        return { [weak self] in
            baseAction?()
            let isNonAlpha = self?.keyboardViewController?.keyboardType != .alphabetic(uppercased: false)
            guard isNonAlpha else { return }
            self?.switchToAlphabeticKeyboard(.lowercased)
        }
    }

    func handleBackspace(for view: UIView) -> GestureAction {
        return { [weak self] in
            self?.inputTools.popLast { currentWord, input, result in
                self?.handleGoogleInputResult(currentWord: currentWord, input: input, result: result)
            }
        }
    }

    func switchToAlphabeticKeyboard(_ state: KeyboardShiftState) {
        keyboardShiftState = state
        keyboardViewController?.keyboardType = .alphabetic(uppercased: state.isUppercased)
    }

    func switchToCapsLockedKeyboard() {
        switchToAlphabeticKeyboard(.capsLocked)
    }

    func switchToLowercaseKeyboard() {
        switchToAlphabeticKeyboard(.lowercased)
    }

    func switchToUppercaseKeyboard() {
        switchToAlphabeticKeyboard(.uppercased)
    }
}
