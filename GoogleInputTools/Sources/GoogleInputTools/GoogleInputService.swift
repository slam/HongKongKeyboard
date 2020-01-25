import Foundation

//
// Query string:
//
// text: |你好,ma
// itc: yue-hant-t-i0-und
// num: 13
// cp: 0
// cs: 1
// ie: utf-8
// oe: utf-8
// app: demopage
//
class GoogleInputService: NSObject, GoogleInputServiceProtocol {
    func send(currentWord: String, input: String, completion: @escaping (GoogleInputResult) -> Void) {
        guard currentWord.count > 0 || input.count > 0 else {
            return
        }

        var components = URLComponents(string: "https://inputtools.google.com/request")!
        let text = currentWord.isEmpty ? input.lowercased() : "|\(currentWord),\(input.lowercased())"
        components.queryItems = [
            URLQueryItem(name: "text", value: text),
            URLQueryItem(name: "itc", value: "yue-hant-t-i0-und"),
            URLQueryItem(name: "num", value: "30"),
            URLQueryItem(name: "cp", value: "0"),
            URLQueryItem(name: "cs", value: "1"),
            URLQueryItem(name: "ie", value: "utf-8"),
            URLQueryItem(name: "oe", value: "utf-8"),
            URLQueryItem(name: "app", value: "demopage"),
        ]
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        var request = URLRequest(url: components.url!)
        request.httpMethod = "POST"

        let task = URLSession.shared.dataTask(with: request) { result in
            switch result {
            case let .success(_, data):
                do {
                    let res = try JSONDecoder().decode(GoogleInputResponse.self, from: data)
                    completion(Result.success(res))
                } catch {
                    print(error)
                    print(String(data: data, encoding: String.Encoding.utf8)!)
                    completion(Result.failure(error))
                }
            case let .failure(error):
                print(error)
                completion(Result.failure(error))
            }
        }
        task.resume()
    }
}
