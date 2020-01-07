import Foundation

protocol GoogleInputServiceProtocol {
    func send(currentWord: String, input: String, completion: @escaping (GoogleInputResult) -> Void)
}
