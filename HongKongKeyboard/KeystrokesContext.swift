import SwiftUI

public class KeystrokesContext: ObservableObject {

    public init() {}

    @Published public var keystrokes = ""

    public func update(_ text: String) {
        self.keystrokes = text
    }
}
