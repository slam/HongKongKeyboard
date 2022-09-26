import Combine
import GoogleInputTools

public class InputToolsContext: ObservableObject {
    public init() {
        input = String()
    }

    @Published
    public private(set) var input: String

    public func append(_ char: String) {
        input.append(char)
    }

    public func pick(_ suggestion: GoogleInputSuggestion) {
        let length = suggestion.matchedLength
        input = String(input.dropFirst(length))
    }

    public func popLast() -> Character? {
        guard let char = input.popLast() else {
            return nil
        }
        return char
    }

    public func reset() {
        input = ""
    }
}
