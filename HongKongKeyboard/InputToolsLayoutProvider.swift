import KeyboardKit

class InputToolsLayoutProvider: StandardKeyboardLayoutProvider {
    override func keyboardLayout(for context: KeyboardContext) -> KeyboardLayout {
        let layout = super.keyboardLayout(for: context)
        var rows = layout.itemRows

        let rowIndex = rows.count - 1
        guard let system = (rows[rowIndex].first { $0.action.isSystemAction }) else { return layout }

        let switcher = KeyboardLayoutItem(action: .character("'"), size: system.size, insets: system.insets)
        rows.insert(switcher, after: .space, atRow: rowIndex)

        return KeyboardLayout(itemRows: rows)
    }
}
