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
        addTrailingSubview(suggestionSeparator, width: 0.5, height: 20.0)
        addTapAction { [weak self] in
            guard let word = self?.inputTools?.pickSuggestion(suggestion) else {
                return
            }
            self?.proxy?.insertText(word)
            self?.keyboardViewController?.requestSuggestions()
        }
    }

    var edgeInsets: UIEdgeInsets = UIEdgeInsets.zero

    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        var rect = super.textRect(forBounds: bounds.inset(by: edgeInsets), limitedToNumberOfLines: numberOfLines)

        rect.origin.x -= edgeInsets.left - 8
        rect.origin.y -= edgeInsets.top
        rect.size.width += (edgeInsets.left + edgeInsets.right) + 8
        rect.size.height += (edgeInsets.top + edgeInsets.bottom)

        return rect
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: edgeInsets))
    }

    public lazy var suggestionSeparator: SuggestionSeparator = {
        SuggestionSeparator()
    }()

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
