import GoogleInputTools
import KeyboardKit
import UIKit

class HongKongKeyboardActionHandler: StandardKeyboardActionHandler {
    // MARK: - Initialization

    public init(inputViewController: UIInputViewController,
                googleInputTools: GoogleInputTools) {
        keyboardShiftState = .lowercased
        inputTools = googleInputTools
        super.init(
            inputViewController: inputViewController,
            hapticConfiguration: .standard
        )
    }

    // MARK: - Properties

    private var inputTools: GoogleInputTools

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
        case .newLine: return handleNewline(for: view)
        case .function: return handleApostrophe(for: view)
        case let .switchToKeyboard(type): return { [weak self] in self?.keyboardViewController?.keyboardType = type }
        default: return super.tapAction(for: action, view: view)
        }
    }

    // MARK: - Action Handling

    override func handle(_ gesture: KeyboardGesture, on action: KeyboardAction, view: UIView) {
        print("handle called")
        super.handle(gesture, on: action, view: view)
        keyboardViewController?.requestSuggestions()
    }
}

// MARK: - Actions

private extension HongKongKeyboardActionHandler {
    func alert(_ message: String) {
        guard let input = inputViewController as? KeyboardViewController else { return }
        input.alerter.alert(message: message, in: input.view, withDuration: 4)
    }

    func updateSpacebarText(_ message: String) {
        guard let input = inputViewController as? KeyboardViewController else { return }
        input.updateSpacebarText(message)
    }

    func updateToolbar(_ response: GoogleInputResponse) {
        guard let input = inputViewController as? KeyboardViewController else { return }

        var count = 0
        var suggestions = [GoogleInputSuggestion]()
        for suggestion in response.suggestions {
            count += suggestion.word.count
            if count < 15 {
                suggestions.append(suggestion)
            }
        }
        input.suggestionToolbar.update(with: suggestions)
    }

    func handleGoogleInputResult(currentWord: String, input: String, result: GoogleInputResult) {
        switch result {
        case let .success(response):
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
                self.updateSpacebarText(input)
                self.updateToolbar(response)
            }
        case let .failure(error):
            DispatchQueue.main.async {
                self.alert(error.localizedDescription)
            }
        }
    }

    func handleCharacter(_ action: KeyboardAction, for view: UIView) -> GestureAction {
        let baseAction = super.tapAction(for: action, view: view)
        return { [weak self] in
            switch action {
            case let .character(char):
                if (char >= "a" && char <= "z") || (char >= "A" && char <= "Z") {
                    self?.inputTools.append(char) { currentWord, input, result in
                        self?.handleGoogleInputResult(currentWord: currentWord, input: input, result: result)
                    }
                } else {
                    baseAction?()
                }
            default: return
            }
        }
    }

    func handleApostrophe(for view: UIView) -> GestureAction {
        return { [weak self] in
            self?.inputTools.append("'") { currentWord, input, result in
                self?.handleGoogleInputResult(currentWord: currentWord, input: input, result: result)
            }
        }
    }

    func handleSpace(for view: UIView) -> GestureAction {
        let suggestion = inputTools.pickSuggestion(0)
        let action: KeyboardAction = suggestion != nil ? .character(suggestion!) : .space
        let baseAction = super.tapAction(for: action, view: view)
        return { [weak self] in
            baseAction?()
            if suggestion == nil {
                let isNonAlpha = self?.keyboardViewController?.keyboardType != .alphabetic(uppercased: false)
                guard isNonAlpha else { return }
                self?.switchToAlphabeticKeyboard(.lowercased)
            }
        }
    }

    func handleNewline(for view: UIView) -> GestureAction {
        let input = inputTools.input
        let action: KeyboardAction = input.count > 0 ? .character(input) : .newLine
        let baseAction = super.tapAction(for: action, view: view)
        return { [weak self] in
            baseAction?()
            if input.count > 0 {
                self?.inputTools.reset()
            }
        }
    }

    func handleBackspace(for view: UIView) -> GestureAction {
        let baseAction = super.tapAction(for: .backspace, view: view)
        return { [weak self] in
            let char = self?.inputTools.popLast { currentWord, input, result in
                self?.handleGoogleInputResult(currentWord: currentWord, input: input, result: result)
            }

            if char == nil {
                baseAction?()
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
