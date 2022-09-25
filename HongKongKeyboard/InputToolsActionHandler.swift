import GoogleInputTools
import KeyboardKit

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
        case .character: return handleCharacter(action)
        // case .space: return handleSpace(sender: sender)
        case .backspace: return handleBackspace(action)
        // case .newLine: return handleNewline(sender: sender)
        // case .function: return handleApostrophe(sender: sender)
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
        switch action {
        case let .character(char):
            if (char >= "a" && char <= "z") || (char >= "A" && char <= "Z") {
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
        if inputToolsContext.input != "" {
            return { _ in
                _ = self.inputToolsContext.popLast()
            }
        }

        return action.standardTapAction
    }

//    func handleApostrophe(sender: Any?) -> GestureAction {
//        { [weak self] in
//            self?.inputTools.append("'") { currentWord, input, result in
//                self?.handleGoogleInputResult(currentWord: currentWord, input: input, result: result)
//            }
//        }
//    }
//
//    func handleSpace(_ action: KeyboardAction) -> KeyboardAction.GestureAction? {
//        let suggestion = inputTools.pickSuggestion(0)
//        let action: KeyboardAction = suggestion != nil ? .character(suggestion!) : .space
//        let baseAction = super.tapAction(for: action, sender: sender)
//        return { [weak self] in
//            baseAction?()
//            self?.inputViewController?.changeKeyboardType(to: .alphabetic(.lowercased))
//        }
//    }
//
//    func handleNewline(sender: Any?) -> GestureAction {
//        let input = inputTools.input
//        let action: KeyboardAction = input.count > 0 ? .character(input) : .newLine
//        let baseAction = super.tapAction(for: action, sender: sender)
//        return { [weak self] in
//            baseAction?()
//            if input.count > 0 {
//                self?.inputTools.reset()
//            }
//        }
//    }
//
}
