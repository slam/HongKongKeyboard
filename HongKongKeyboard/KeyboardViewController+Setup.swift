import KeyboardKit
import UIKit

extension KeyboardViewController {
    func setupKeyboard() {
        setupKeyboard(for: view.bounds.size)
    }

    func setupKeyboard(for size: CGSize) {
        DispatchQueue.main.async {
            self.setupKeyboardAsync(for: size)
        }
    }

    func setupKeyboardAsync(for size: CGSize) {
        keyboardStackView.removeAllArrangedSubviews()
        switch keyboardType {
        case let .alphabetic(uppercased): setupAlphabeticKeyboard(uppercased: uppercased, for: size)
        case .numeric: setupNumericKeyboard(for: size)
        default: return
        }
    }

    func setupAlphabeticKeyboard(uppercased: Bool = false, for size: CGSize) {
        let keyboard = AlphabeticKeyboard(uppercased: uppercased, in: self)
        let rows = buttonRows(for: keyboard.actions, distribution: .equalSpacing, size: size)
        keyboardStackView.addArrangedSubviews(rows)
    }

    func setupNumericKeyboard(for size: CGSize) {
        let keyboard = NumericKeyboard(in: self)
        let rows = buttonRows(for: keyboard.actions, distribution: .equalSpacing, size: size)
        keyboardStackView.addArrangedSubviews(rows)
    }
}
