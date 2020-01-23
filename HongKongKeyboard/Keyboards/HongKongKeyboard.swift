import KeyboardKit

protocol HongKongKeyboard {}

extension HongKongKeyboard {
    static func bottomActions(leftmost: KeyboardAction,
                              for viewController: KeyboardViewController) -> KeyboardActionRow {
        let comma = viewController.keyboardType == .numeric ? "," : "，"
        let period = viewController.keyboardType == .numeric ? "." : "。"
        return (viewController.needsInputModeSwitchKey ? [leftmost, .switchKeyboard] : [leftmost])
            + [.character(comma), .space, .character(period), .newLine]
    }
}
