import KeyboardKit
import SwiftUI

struct KeyboardView: View {
    @State private var text = "Text"

    @EnvironmentObject private var context: KeyboardContext

    var body: some View {
        VStack(spacing: 0) {
            KeyboardAutocompleteToolbar()
            SystemKeyboard()
        }
    }
}
