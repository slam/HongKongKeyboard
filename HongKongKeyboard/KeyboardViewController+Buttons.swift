import KeyboardKit
import UIKit

extension KeyboardViewController {
    func button(for action: KeyboardAction, distribution: UIStackView.Distribution = .equalSpacing) -> UIView {
        if action == .none { return KeyboardSpacerView(width: 10) }
        let view = HongKongKeyboardButton.fromNib(owner: self)
        view.setup(with: action, in: self, distribution: distribution)
        return view
    }

    func buttonRow(for actions: KeyboardActionRow,
                   distribution: UIStackView.Distribution) -> KeyboardStackViewComponent {
        KeyboardButtonRow(actions: actions, distribution: distribution) {
            button(for: $0, distribution: distribution)
        }
    }

    func buttonRows(for actionRows: KeyboardActionRows,
                    distribution: UIStackView.Distribution) -> [KeyboardStackViewComponent] {
        var rows = actionRows.map {
            buttonRow(for: $0, distribution: distribution)
        }
        rows.insert(autocompleteToolbar, at: 0)
        return rows
    }
}
