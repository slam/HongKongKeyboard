import GoogleInputTools
import KeyboardKit
import KeyboardKitSwiftUI
import SwiftUI

extension HongKongKeyboardView {

    var systemKeyboard: some View {
        VStack(spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
                AutocompleteToolbar(buttonBuilder: autocompleteButtonBuilder,
                                    replacementAction: replacementAction)
            }
            .frame(height: 40)
            SystemKeyboard(layout: systemKeyboardLayout, buttonBuilder: buttonBuilder)
        }
    }

    var systemKeyboardLayout: KeyboardLayout {
        context.keyboardLayoutProvider.keyboardLayout(for: context)
    }

    var toastBackground: some View {
        Color.white
            .cornerRadius(3)
            .shadow(color: Color.black.opacity(0.3), radius: 2, x: 1, y: 1)
    }
}

private extension HongKongKeyboardView {

    func autocompleteButton(for suggestion: AutocompleteSuggestion) -> AnyView {
        guard let subtitle = suggestion.subtitle else { return AutocompleteToolbar.standardButton(for: suggestion) }
        return AnyView(VStack(spacing: 0) {
            Text(suggestion.title).font(.callout)
            Text(subtitle).font(.footnote)
        }.frame(maxWidth: .infinity))
    }

    func autocompleteButtonBuilder(suggestion: AutocompleteSuggestion) -> AnyView {
        AnyView(autocompleteButton(for: suggestion)
            .background(Color.clearInteractable))
    }

    func buttonBuilder(action: KeyboardAction, size: CGSize) -> AnyView {
        switch action {
        case .space: return AnyView(SystemKeyboardSpaceButtonContent(localeText: "香港", spaceText: "粵語拼音"))
        default: return SystemKeyboard.standardButtonBuilder(action: action, keyboardSize: size)
        }
    }
}
