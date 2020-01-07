import Foundation

protocol GoogleInputServiceProtocol: class {
    func send(currentWord: String, input: String, completion: @escaping (GoogleInputResult) -> Void)
}
