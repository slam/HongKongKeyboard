import KeyboardKit
import UIKit

class HongKongKeyboardActionHandler: StandardKeyboardActionHandler {
    // MARK: - Initialization

    public init(inputViewController: UIInputViewController) {
        keyboardShiftState = .lowercased
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

    func handleCharacter(_ action: KeyboardAction, for view: UIView) -> GestureAction {
        let baseAction = super.tapAction(for: action, view: view)
        return { [weak self] in
            baseAction?()
            let isUppercased = self?.keyboardShiftState == .uppercased
            guard isUppercased else { return }
            self?.switchToAlphabeticKeyboard(.lowercased)
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
