import KeyboardKit
import UIKit

extension KeyboardViewController {
    func button(for action: KeyboardAction,
                distribution: UIStackView.Distribution = .equalSpacing,
                size: CGSize) -> UIView {
        if action == .none { return KeyboardSpacerView(width: size.width / 10 / 3) }
        let view = HongKongKeyboardButton.fromNib(owner: self)
        view.setup(with: action, in: self, distribution: distribution, size: size)
        if action == .space {
            spacebarView = view
        }
        return view
    }

    func buttonRow(for actions: KeyboardActionRow,
                   distribution: UIStackView.Distribution,
                   size: CGSize) -> KeyboardStackViewComponent {
        KeyboardButtonRow(actions: actions, distribution: distribution) {
            button(for: $0, distribution: distribution, size: size)
        }
    }

    func buttonRows(for actionRows: KeyboardActionRows,
                    distribution: UIStackView.Distribution,
                    size: CGSize) -> [KeyboardStackViewComponent] {
        var rows = actionRows.map {
            buttonRow(for: $0, distribution: distribution, size: size)
        }
        rows.insert(suggestionToolbar, at: 0)
        return rows
    }
}
