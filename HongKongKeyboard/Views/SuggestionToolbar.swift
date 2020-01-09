import CoreGraphics
import GoogleInputTools
import KeyboardKit
import UIKit

public class SuggestionToolbar: KeyboardToolbar {
    // MARK: - Initialization

    public init(buttonCreator: @escaping ButtonCreator) {
        self.buttonCreator = buttonCreator
        super.init(height: .standardKeyboardRowHeight, alignment: .fill, distribution: .fillProportionally)
        stackView.spacing = 0
    }

    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Types

    public typealias ButtonCreator = (GoogleInputSuggestion) -> (UIView)

    // MARK: - Properties

    private let buttonCreator: ButtonCreator

    private var suggestions: [GoogleInputSuggestion] = [] {
        didSet {
            let buttons = suggestions.map { buttonCreator($0) }
            stackView.removeAllArrangedSubviews()
            stackView.addArrangedSubviews(buttons)
        }
    }

    // MARK: - Functions

    /**
     Reset the toolbar by removing all suggestions.
     */
    public func reset() {
        update(with: [])
    }

    /**
     Update the toolbar with new words. This will remove all
     previously added views from the stack view and create a
     new set of views for the new word collection.
     */
    public func update(with suggestions: [GoogleInputSuggestion]) {
        self.suggestions = suggestions
    }
}
