import GoogleInputTools
import KeyboardKit
import KeyboardKitSwiftUI
import SwiftUI
import Combine

class KeyboardViewController: KeyboardInputViewController {

    // MARK: - View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup(with: keyboardView)
        context.actionHandler = HongKongKeyboardActionHandler(
            inputViewController: self,
            toastContext: toastContext,
            googleInputTools: inputTools)
        context.keyboardAppearanceProvider = HongKongKeyboardAppearanceProvider()
        context.keyboardLayoutProvider = StandardKeyboardLayoutProvider(
            leftSpaceAction: .character("，"), rightSpaceAction: .character("。"))
        context.keyboardInputSetProvider = HongKongKeyboardInputSetProvider()
        context.locale = Locale.init(identifier: "zh")
    }

    // MARK: - Properties

    private var cancellables = [AnyCancellable]()

    private let toastContext = KeyboardToastContext()

    private var keyboardView: some View {
        HongKongKeyboardView(controller: self, inputTools: inputTools) { [weak self] suggestion, _ in
            guard let pick = suggestion.additionalInfo["suggestion"] as? GoogleInputSuggestion else { return }
            guard let word = self?.inputTools.pickSuggestion(pick) else { return }
            self?.textDocumentProxy.insertText(word)
            // textDidChange not firing - https://developer.apple.com/forums/thread/45121
            self?.performAutocomplete()
        }
            .environmentObject(autocompleteContext)
            .environmentObject(toastContext)
    }

    let inputTools = GoogleInputTools()

//    var spacebarView: HongKongKeyboardButton?

    // MARK: - Keyboard Functionality

    open override func viewWillLayoutSubviews() {
        context.hasDictationKey = hasDictationKey
        // Hack to shut up the horrific log spam
        context.needsInputModeSwitchKey = false
    }

    func updateSpacebarText(_ message: String) {
//        spacebarView?.textLabel?.text = message.count > 0 ? message : "粵語拼音"
    }

    // MARK: - Autocomplete

    struct Suggestion: AutocompleteSuggestion {

        public var replacement: String
        public var title: String { replacement }
        public var subtitle: String?
        public var additionalInfo: [String: Any]
    }

    private lazy var autocompleteContext = ObservableAutocompleteContext()

    func updateAutocompleteToolbar(_ suggestions: [GoogleInputResponse.Suggestion]) {
        autocompleteContext.suggestions = suggestions.map{
            Suggestion(replacement: $0.word,
                       additionalInfo: ["suggestion": $0])}
    }

    override func performAutocomplete() {
        guard let word = textDocumentProxy.currentWord else { return resetAutocomplete() }
        print("performAutocomplete word=\(word)")

        guard word.count > 0 else { return resetAutocomplete() }

        inputTools.updateCurrentWord(word) { [weak self] _, _, result in
            switch result {
            case let .success(response):
                guard response.status == GoogleInputResponse.Status.success else {
                    print(response.status.rawValue)
                    return
                }
                DispatchQueue.main.async {
                    self?.updateAutocompleteToolbar(response.suggestions)
                    // TODO: update space bar text with input
                }
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }

    override func resetAutocomplete() {
        autocompleteContext.suggestions = []
    }
}
