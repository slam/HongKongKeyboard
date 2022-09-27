import KeyboardKit
import SwiftUI
import SwiftUIKit

struct HomeScreen: View {
    @StateObject private var keyboardState = KeyboardEnabledState(bundleId: "com.sahnlam.HongKongKeyboardApp.keyboard")
    @State private var text = ""

    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField(
                        "不妨試試",
                        text: $text
                    )
                    EnabledListItem(
                        isEnabled: isKeyboardActive,
                        enabledText: "粵語拼音 is selected",
                        disabledText: "粵語拼音 is not selected"
                    )
                }
                Section(header: Text("Keyboard"), footer: footerText) {
                    EnabledListItem(
                        isEnabled: isKeyboardEnabled,
                        enabledText: "粵語拼音 is enabled",
                        disabledText: "粵語拼音 is disabled"
                    )
                    EnabledListItem(
                        isEnabled: isFullAccessEnabled,
                        enabledText: "Full Access is enabled",
                        disabledText: "Full Access is disabled"
                    )
                    ListNavigationButton(action: openSettings) {
                        Label("Settings", image: .settings)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("粵語拼音")
        }
        .navigationViewStyle(.stack)
        .environmentObject(keyboardState)
    }
}

private extension HomeScreen {
    var footerText: some View {
        Text("To install, add 粵語拼音 as a new keyboard in Settings ➔ General ➔ Keyboards and grant Full Access.")
    }
}

private extension HomeScreen {
    var isFullAccessEnabled: Bool {
        keyboardState.isFullAccessEnabled
    }

    var isKeyboardEnabled: Bool {
        keyboardState.isKeyboardEnabled
    }

    var isKeyboardActive: Bool {
        keyboardState.isKeyboardCurrentlyActive
    }

    func openSettings() {
        guard let url = URL.keyboardSettings else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
