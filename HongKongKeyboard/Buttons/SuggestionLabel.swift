import GoogleInputTools
import KeyboardKit
import UIKit

class SuggestionLabel: UILabel {
    convenience init(suggestion: GoogleInputSuggestion,
                     proxy: UITextDocumentProxy,
                     inputTools: GoogleInputTools,
                     keyboardViewController: KeyboardViewController) {
        self.init(frame: .zero)
        self.proxy = proxy
        self.inputTools = inputTools
        self.keyboardViewController = keyboardViewController
        text = suggestion.word
        textAlignment = .center
        accessibilityTraits = .button
        textColor = textColor(for: proxy)
        addTapAction { [weak self] in
            guard let word = self?.inputTools?.pickSuggestion(suggestion) else {
                return
            }
            self?.proxy?.insertText(word)
            self?.keyboardViewController?.requestSuggestions()
        }
    }

    private weak var proxy: UITextDocumentProxy?
    private weak var inputTools: GoogleInputTools?
    private weak var keyboardViewController: KeyboardViewController?
}

private extension SuggestionLabel {
    func textColor(for proxy: UITextDocumentProxy) -> UIColor {
        let asset = proxy.keyboardAppearance == .dark
            ? Asset.Colors.darkButtonText
            : Asset.Colors.lightButtonText
        return asset.color
    }
}
