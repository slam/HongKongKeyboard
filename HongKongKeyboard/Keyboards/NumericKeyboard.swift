import KeyboardKit

/**
 This keyboard mimicks an English numeric keyboard.
 */
struct NumericKeyboard: HongKongKeyboard {
    init(in viewController: KeyboardViewController) {
        actions = type(of: self).actions(in: viewController)
    }

    let actions: KeyboardActionRows
}

private extension NumericKeyboard {
    static func actions(in viewController: KeyboardViewController) -> KeyboardActionRows {
        KeyboardActionRows
            .from(characters)
            .addingSideActions()
            .appending(bottomActions(leftmost: switchAction, for: viewController))
    }

    static let characters: [[String]] = [
        ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
        ["-", "/", ":", ";", "(", ")", "$", "&", "@", "\""],
        [".", ",", "?", "!", "´"],
    ]

    static var switchAction: KeyboardAction {
        .switchToKeyboard(.alphabetic(uppercased: false))
    }
}

private extension Sequence where Iterator.Element == KeyboardActionRow {
    func addingSideActions() -> [Iterator.Element] {
        var actions = map { $0 }
        actions[2].insert(.switchToKeyboard(.symbolic), at: 0)
        actions[2].insert(.none, at: 1)
        actions[2].append(.none)
        actions[2].append(.backspace)
        return actions
    }
}
