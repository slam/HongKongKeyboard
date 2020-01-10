import KeyboardKit

protocol HongKongKeyboard {}

extension HongKongKeyboard {
    static func bottomActions(leftmost: KeyboardAction,
                              for viewController: KeyboardViewController) -> KeyboardActionRow {
        (viewController.needsInputModeSwitchKey ? [leftmost, .switchKeyboard] : [leftmost])
            + [.character("，"), .space, .character("。"), .newLine]
    }
}
