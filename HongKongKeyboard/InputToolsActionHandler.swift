import GoogleInputTools
import KeyboardKit
import UIKit

class InputToolsActionHandler: StandardKeyboardActionHandler {
    public init(
        inputViewController: KeyboardViewController,
        inputToolsContext: InputToolsContext
    ) {
        self.inputToolsContext = inputToolsContext
        super.init(inputViewController: inputViewController)
    }

    private let inputToolsContext: InputToolsContext

    func tapAction(for action: KeyboardAction) -> KeyboardAction.GestureAction? {
        switch action {
        case .character, .characterMargin: return handleCharacter(action)
        case .space: return handleSpace(action)
        case .backspace: return handleBackspace(action)
        case .return, .newLine: return handleNewline(action)
        case .custom: return handleLocaleChange(action)
        default: return action.standardTapAction
        }
    }

    override func action(for gesture: KeyboardGesture, on action: KeyboardAction) -> KeyboardAction.GestureAction? {
        switch gesture {
        case .tap: return tapAction(for: action)
        default: return super.action(for: gesture, on: action)
        }
    }

    func handleCharacter(_ action: KeyboardAction) -> KeyboardAction.GestureAction? {
        guard keyboardContext.locale == Locale(identifier: "zh") else {
            return action.standardTapAction
        }
        switch action {
        case let .character(char), let .characterMargin(char):
            // Use ' to explicitly separates pronunciation of two characters.
            // For example, "long" can be interpreted into "long" or "lo-ng",
            // while "lo'ng" will only be interpreted into "lo-ng".
            if (char >= "a" && char <= "z") || (char >= "A" && char <= "Z") || (char == "'") {
                return { _ in
                    self.inputToolsContext.append(char)
                }
            }
        default:
            break
        }

        return action.standardTapAction
    }

    func handleBackspace(_ action: KeyboardAction) -> KeyboardAction.GestureAction? {
        guard inputToolsContext.input != "" else { return action.standardTapAction }
        return { _ in
            _ = self.inputToolsContext.popLast()
        }
    }

    func handleSpace(_ action: KeyboardAction) -> KeyboardAction.GestureAction? {
        guard autocompleteContext.suggestions.count > 0 else { return action.standardTapAction }
        let suggestion = autocompleteContext.suggestions[0]
        return {
            switch suggestion.additionalInfo["suggestion"] {
            case let inputToolsSuggestion as GoogleInputSuggestion:
                self.inputToolsContext.pick(inputToolsSuggestion)
            default:
                break
            }
            $0?.textDocumentProxy.insertText(suggestion.text)
        }
    }

    func handleNewline(_ action: KeyboardAction) -> KeyboardAction.GestureAction? {
        // Hit `Enter` to type in the English letters entered so far.
        guard inputToolsContext.input.count > 0 else { return action.standardTapAction }

        return {
            let input = self.inputToolsContext.input
            self.inputToolsContext.reset()
            $0?.textDocumentProxy.insertText(input)
        }
    }

    func handleLocaleChange(_: KeyboardAction) -> KeyboardAction.GestureAction? {
        return { _ in
            switch self.keyboardContext.locale {
            case Locale(identifier: "en"): self.keyboardContext.locale = Locale(identifier: "zh")
            default:
                self.inputToolsContext.reset()
                self.keyboardContext.locale = Locale(identifier: "en")
            }
        }
    }
}
