import Foundation

protocol GoogleInputServiceProtocol: AnyObject {
    func send(currentWord: String, input: String, completion: @escaping (GoogleInputResult) -> Void)
}
