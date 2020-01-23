import KeyboardKit
import UIKit

class HongKongKeyboardButton: KeyboardButtonView {
    public func setup(with action: KeyboardAction,
                      in viewController: KeyboardInputViewController,
                      distribution: UIStackView.Distribution = .fillEqually,
                      size: CGSize) {
        super.setup(with: action, in: viewController)
        backgroundColor = .clearTappable
        buttonView?.backgroundColor = action.buttonColor(for: viewController)
        DispatchQueue.main.async { self.image?.image = action.buttonImage }
        textLabel?.font = action.buttonFont
        textLabel?.text = action.buttonText
        textLabel?.textColor = action.tintColor(in: viewController)
        buttonView?.tintColor = action.tintColor(in: viewController)
        width = action.buttonWidth(for: distribution, size: size,
                                   needsSwitchKeyboard: viewController.needsInputModeSwitchKey)
        applyShadow(.standardButtonShadow)
    }

    @IBOutlet var buttonView: UIView? {
        didSet { buttonView?.layer.cornerRadius = 7 }
    }

    @IBOutlet var image: UIImageView?

    @IBOutlet var textLabel: UILabel? {
        didSet { textLabel?.text = "" }
    }
}

// MARK: - Private button-specific KeyboardAction Extensions

private extension KeyboardAction {
    func buttonColor(for viewController: KeyboardInputViewController) -> UIColor {
        let dark = useDarkAppearance(in: viewController)
        let asset = useDarkButton
            ? (dark ? Asset.Colors.darkSystemButton : Asset.Colors.lightSystemButton)
            : (dark ? Asset.Colors.darkButton : Asset.Colors.lightButton)
        return asset.color
    }

    var buttonFont: UIFont {
        .preferredFont(forTextStyle: buttonFontStyle)
    }

    var buttonFontStyle: UIFont.TextStyle {
        switch self {
        case .character: return .title2
        default: return .body
        }
    }

    var buttonImage: UIImage? {
        switch self {
        case let .image(_, imageName, _): return UIImage(named: imageName)
        case .switchKeyboard: return Asset.Images.Buttons.switchKeyboard.image
        default: return nil
        }
    }

    var buttonText: String? {
        switch self {
        case .backspace: return "⌫"
        case let .character(text): return text
        case .newLine: return "return"
        case .shift, .shiftDown: return "⇧"
        case .space: return "粵語拼音"
        case .function: return "'詞"
        case let .switchToKeyboard(type): return buttonText(for: type)
        default: return nil
        }
    }

    func buttonText(for keyboardType: KeyboardType) -> String {
        switch keyboardType {
        case .alphabetic: return "ABC"
        case .numeric: return "123"
        default: return "???"
        }
    }

    func buttonWidth(for _: UIStackView.Distribution,
                     size: CGSize,
                     needsSwitchKeyboard: Bool) -> CGFloat {
        let unitWidth = size.width / 10 // 10 keys per row
        switch self {
        case .shift, .shiftDown: return unitWidth + unitWidth / 3
        case .backspace: return unitWidth * 1.5
        case .function: return unitWidth / 3
        case .switchKeyboard: return unitWidth
        case .switchToKeyboard: return needsSwitchKeyboard ? unitWidth : unitWidth * 1.5
        case .newLine: return needsSwitchKeyboard ? unitWidth : unitWidth * 1.5
        case .space: return unitWidth * 5
        default: return unitWidth
        }
    }

    func tintColor(in viewController: KeyboardInputViewController) -> UIColor {
        let dark = useDarkAppearance(in: viewController)
        let asset = useDarkButton
            ? (dark ? Asset.Colors.darkSystemButtonText : Asset.Colors.lightSystemButtonText)
            : (dark ? Asset.Colors.darkButtonText : Asset.Colors.lightButtonText)
        return asset.color
    }

    func useDarkAppearance(in viewController: KeyboardInputViewController) -> Bool {
        let appearance = viewController.textDocumentProxy.keyboardAppearance ?? .default
        return appearance == .dark
    }

    var useDarkButton: Bool {
        switch self {
        case .character, .image, .shiftDown, .space: return false
        default: return true
        }
    }
}
