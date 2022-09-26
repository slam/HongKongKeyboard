import KeyboardKit
import SwiftUI

class InputToolsAppearance: StandardKeyboardAppearance {
    override init(context: KeyboardContext) {
        self.context = context
        super.init(context: context)
    }

    private let context: KeyboardContext

    override func buttonText(for action: KeyboardAction) -> String? {
        switch action {
        case let .custom(name):
            switch context.locale {
            case Locale(identifier: "en"): return "英"
            default: return name
            }
        default:
            return super.buttonText(for: action)
        }
    }
}
