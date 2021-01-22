import GoogleInputTools
import KeyboardKit
import KeyboardKitSwiftUI
import UIKit

class HongKongKeyboardActionHandler: StandardKeyboardActionHandler {
    // MARK: - Initialization

    public init(
        inputViewController: KeyboardViewController,
        toastContext: KeyboardToastContext,
        googleInputTools: GoogleInputTools) {
        self.toastContext = toastContext
        inputTools = googleInputTools
        super.init(inputViewController: inputViewController)
    }

    // MARK: - Properties

    private let toastContext: KeyboardToastContext

    private let inputTools: GoogleInputTools

    private var keyboardViewController: KeyboardViewController? {
        inputViewController as? KeyboardViewController
    }

    // MARK: - Actions

    override func tapAction(for action: KeyboardAction, sender: Any?) -> GestureAction? {
        switch action {
        case .character: return handleCharacter(action, sender: sender)
        case .space: return handleSpace(sender: sender)
        case .backspace: return handleBackspace(sender: sender)
        case .newLine: return handleNewline(sender: sender)
        case .function: return handleApostrophe(sender: sender)
        default: return super.tapAction(for: action, sender: sender)
        }
    }

    func alert(_ message: String) {
        toastContext.present(message)
    }
}

// MARK: - Actions

private extension HongKongKeyboardActionHandler {

    func updateSpacebarText(_ message: String) {
        guard let input = inputViewController as? KeyboardViewController else { return }
        input.updateSpacebarText(message)
    }

    func updateToolbar(_ response: GoogleInputResponse) {
        guard let input = inputViewController as? KeyboardViewController else { return }
        input.updateAutocompleteToolbar(response.suggestions)
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

    func handleCharacter(_ action: KeyboardAction, sender: Any?) -> GestureAction {
        let baseAction = super.tapAction(for: action, sender: sender)
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

    func handleApostrophe(sender: Any?) -> GestureAction {
        { [weak self] in
            self?.inputTools.append("'") { currentWord, input, result in
                self?.handleGoogleInputResult(currentWord: currentWord, input: input, result: result)
            }
        }
    }

    func handleSpace(sender: Any?) -> GestureAction {
        let suggestion = inputTools.pickSuggestion(0)
        let action: KeyboardAction = suggestion != nil ? .character(suggestion!) : .space
        let baseAction = super.tapAction(for: action, sender: sender)
        return { [weak self] in
            baseAction?()
            self?.inputViewController?.changeKeyboardType(to: .alphabetic(.lowercased))
        }
    }

    func handleNewline(sender: Any?) -> GestureAction {
        let input = inputTools.input
        let action: KeyboardAction = input.count > 0 ? .character(input) : .newLine
        let baseAction = super.tapAction(for: action, sender: sender)
        return { [weak self] in
            baseAction?()
            if input.count > 0 {
                self?.inputTools.reset()
            }
        }
    }

    func handleBackspace(sender: Any?) -> GestureAction {
        let baseAction = super.tapAction(for: .backspace, sender: sender)
        return { [weak self] in
            let char = self?.inputTools.popLast { currentWord, input, result in
                self?.handleGoogleInputResult(currentWord: currentWord, input: input, result: result)
            }

            if char == nil {
                baseAction?()
            }
        }
    }
}
