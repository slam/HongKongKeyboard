import CoreGraphics
import GoogleInputTools
import KeyboardKit
import UIKit

class SuggestionToolbar: KeyboardToolbar {
    // MARK: - Initialization

    public init(buttonCreator: @escaping ButtonCreator) {
        self.buttonCreator = buttonCreator
        super.init(height: .standardKeyboardRowHeight, alignment: .fill, distribution: .fillProportionally)
        stackView.spacing = 0
        enableScrolling()
    }

    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Types

    public typealias ButtonCreator = (GoogleInputSuggestion) -> (UIView)

    // MARK: - Properties

    private let buttonCreator: ButtonCreator

    private var scrollView: UIScrollView?

    private var suggestions: [GoogleInputSuggestion] = [] {
        didSet {
            let buttons = suggestions.map { buttonCreator($0) }
            stackView.removeAllArrangedSubviews()
            stackView.addArrangedSubviews(buttons)
            removeLastSeparator(in: buttons)
        }
    }

    // MARK: - Functions

    public func reset() {
        update(with: [])
    }

    private func enableScrolling() {
        guard self.scrollView == nil else { return }
        let scrollView = UIScrollView(frame: .zero)
        addSubview(scrollView, fill: true)
        stackView.removeAllConstraints()
        scrollView.addSubview(stackView, fill: true)
        stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        self.scrollView = scrollView
    }

    public func update(with suggestions: [GoogleInputSuggestion]) {
        self.suggestions = suggestions
    }
}

private extension SuggestionToolbar {
    func removeLastSeparator(in views: [UIView]) {
        guard let view = views.last as? SuggestionLabel else { return }
        view.suggestionSeparator.isHidden = true
    }
}

extension UIView {
    func removeAllConstraints() {
        var parent = superview

        while let superview = parent {
            for constraint in superview.constraints {
                if let first = constraint.firstItem as? UIView, first == self {
                    superview.removeConstraint(constraint)
                }

                if let second = constraint.secondItem as? UIView, second == self {
                    superview.removeConstraint(constraint)
                }
            }

            parent = superview.superview
        }

        removeConstraints(constraints)
        translatesAutoresizingMaskIntoConstraints = true
    }
}
