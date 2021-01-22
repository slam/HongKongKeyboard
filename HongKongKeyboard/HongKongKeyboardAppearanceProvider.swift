import KeyboardKit
import UIKit

class HongKongKeyboardAppearanceProvider: StandardKeyboardAppearanceProvider {

    override func font(for action: KeyboardAction) -> UIFont {
        switch action {
        case .space: return .preferredFont(forTextStyle: .body)
        default: return super.font(for: action)
        }
    }

    override func text(for action: KeyboardAction) -> String? {
        switch action {
        case .space: return "space"
        default: return super.text(for: action)
        }
    }
}
