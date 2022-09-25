//import KeyboardKit
//
//open class HongKongKeyboardInputSetProvider: KeyboardInputSetProvider {
//
//    static var numeric: NumericKeyboardInputSet {
//        NumericKeyboardInputSet(inputRows: [
//            ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
//            ["!", "@", "#", "$", "%", "^", "&", "*", "(", ")"],
//            ["“", "”", "：", "；", "？", "！", "'"]
//        ])
//    }
//
//    public func alphabeticInputSet(for context: KeyboardContext) -> AlphabeticKeyboardInputSet {
//        return KeyboardInputSet.alphabetic_en
//    }
//
//    public func numericInputSet(for context: KeyboardContext) -> NumericKeyboardInputSet {
//        return HongKongKeyboardInputSetProvider.numeric
//    }
//
//    public func symbolicInputSet(for context: KeyboardContext) -> SymbolicKeyboardInputSet {
//        return KeyboardInputSet.symbolic_en
//    }
//}
