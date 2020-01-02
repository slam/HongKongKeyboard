import KeyboardKit

protocol HongKongKeyboard {}

extension HongKongKeyboard {
    static func bottomActions(leftmost: KeyboardAction, for _: KeyboardViewController) -> KeyboardActionRow {
        let actions = [leftmost, .space, .newLine]
        return actions
    }
}
