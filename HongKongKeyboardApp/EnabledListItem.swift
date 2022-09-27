import SwiftUI
import SwiftUIKit

struct EnabledListItem: View {
    let isEnabled: Bool
    let enabledText: String
    let disabledText: String

    var body: some View {
        ListItem {
            Label(
                isEnabled ? enabledText : disabledText,
                image: isEnabled ? .checkmark : .alert
            )
        }.foregroundColor(isEnabled ? .green : .orange)
    }
}

struct EnabledListItem_Previews: PreviewProvider {
    static var previews: some View {
        EnabledListItem(isEnabled: true, enabledText: "Enabled", disabledText: "Disabled")
        EnabledListItem(isEnabled: false, enabledText: "Enabled", disabledText: "Disabled")
    }
}
