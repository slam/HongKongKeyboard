import GoogleInputTools
import SwiftUI
import KeyboardKit
import KeyboardKitSwiftUI

struct HongKongKeyboardView: View {

    let controller: KeyboardInputViewController
    let inputTools: GoogleInputTools
    let replacementAction: AutocompleteToolbar.ReplacementAction

    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @EnvironmentObject var context: ObservableKeyboardContext
    @EnvironmentObject var toastContext: KeyboardToastContext

    var body: some View {
        keyboardView
            .keyboardToast(isActive: $toastContext.isActive, content: toastContext.content, background: toastBackground)
    }

    @ViewBuilder
    var keyboardView: some View {
        switch context.keyboardType {
        case .alphabetic, .numeric, .symbolic: systemKeyboard
        default: Button("???", action: switchToDefaultKeyboard)
        }
    }
}

// MARK: - Functions

private extension HongKongKeyboardView {

    func switchToDefaultKeyboard() {
        context.actionHandler
            .handle(.tap, on: .keyboardType(.alphabetic(.lowercased)))
    }
}
