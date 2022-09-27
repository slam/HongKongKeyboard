import KeyboardKit
import SwiftUI
import SwiftUIKit

struct HomeScreen: View {
    @StateObject private var keyboardState = KeyboardEnabledState(bundleId: "com.sahnlam.HongKongKeyboardApp.keyboard")

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Keyboard"), footer: footerText) {
                    EnabledListItem(
                        isEnabled: isKeyboardEnabled,
                        enabledText: "Keyboard is enabled",
                        disabledText: "Keyboard is disabled"
                    )
                    EnabledListItem(
                        isEnabled: isFullAccessEnabled,
                        enabledText: "Full Access is enabled",
                        disabledText: "Full Access is disabled"
                    )
                    ListNavigationButton(action: openSettings) {
                        Label("System settings", image: .settings)
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
        Text("Enable 粵語拼音 under system settings, then select it with 🌐 when typing.")
    }
}

private extension HomeScreen {
    var isFullAccessEnabled: Bool {
        keyboardState.isFullAccessEnabled
    }

    var isKeyboardEnabled: Bool {
        keyboardState.isKeyboardEnabled
    }

    func openSettings() {
        guard let url = URL.keyboardSettings else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
