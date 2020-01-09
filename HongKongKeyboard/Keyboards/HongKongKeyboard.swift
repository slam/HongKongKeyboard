import KeyboardKit

protocol HongKongKeyboard {}

extension HongKongKeyboard {
    static func bottomActions(leftmost: KeyboardAction, for _: KeyboardViewController) -> KeyboardActionRow {
        let actions = [leftmost, .character("，"), .space, .character("。"), .newLine]
        return actions
    }
}
