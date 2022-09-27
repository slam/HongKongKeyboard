import KeyboardKit

class InputToolsInputSetProvider: LocalizedInputSetProvider {
    let baseProvider = EnglishInputSetProvider()

    public let localeKey: String = "zh"

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
