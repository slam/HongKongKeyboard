import KeyboardKit

class InputToolsInputSetProvider: InputSetProvider {
    let baseProvider = EnglishInputSetProvider()

    var alphabeticInputSet: AlphabeticInputSet {
        baseProvider.alphabeticInputSet
    }

    var numericInputSet: NumericInputSet {
        NumericInputSet(rows: [
            .init("1234567890"),
            .init(phone: "!@#$%^&*()", pad: "!@#$%^&*()"),
            .init(phone: "：；？！'", pad: "“”：；？！'"),
        ])
    }

    var symbolicInputSet: SymbolicInputSet {
        baseProvider.symbolicInputSet
    }
}
