import GoogleInputTools
import KeyboardKit
import SwiftUI

struct KeyboardAutocompleteToolbar: View {
    @EnvironmentObject private var context: AutocompleteContext
    @EnvironmentObject private var keyboardContext: KeyboardContext
    @EnvironmentObject private var inputToolsContext: InputToolsContext

    var body: some View {
        ScrollView(.horizontal) {
            if let error = context.lastError {
                Text(error.localizedDescription).fixedSize()
            } else {
                AutocompleteToolbar(
                    suggestions: context.suggestions,
                    locale: keyboardContext.locale,
                    action: selectSuggestionAction
                ).fixedSize()
            }
        }
        .frame(height: 50)

        Text(inputToolsContext.input)
            .font(.footnote)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    func selectSuggestionAction(for suggestion: AutocompleteSuggestion) {
        let controller = KeyboardInputViewController.shared
        let proxy = controller.textDocumentProxy
        let actionHandler = controller.keyboardActionHandler
        switch suggestion.additionalInfo["suggestion"] {
        case let inputToolsSuggestion as GoogleInputSuggestion:
            inputToolsContext.pick(inputToolsSuggestion)
        default:
            break
        }
        proxy.insertText(suggestion.text)
        actionHandler.handle(.tap, on: .character(""))
    }
}

private extension KeyboardAutocompleteToolbar {
    var isPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
}

struct KeyboardAutocompleteToolbar_Previews: PreviewProvider {
    static var previews: some View {
        KeyboardAutocompleteToolbar()
    }
}
