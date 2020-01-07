import Foundation

//
// Response:
//
// [
//   "SUCCESS",
//   [
//      [
//         "ma",
//         [
//            "嗎",
//            "馬",
//            "買",
//            "媽",
//            "碼",
//            "埋",
//            "麻",
//            "賣",
//            "孖",
//            "物",
//            "嘛",
//            "咪",
//            "乜"
//         ],
//         [
//
//         ],
//         {
//            "annotation":[
//               "ma",
//               "ma",
//               "maai",
//               "ma",
//               "ma",
//               "maai",
//               "ma",
//               "maai",
//               "ma",
//               "mat",
//               "ma",
//               "maai",
//               "mat"
//            ],
//            "candidate_type":[
//               0,
//               0,
//               0,
//               0,
//               0,
//               0,
//               0,
//               0,
//               0,
//               0,
//               0,
//               0,
//               0
//            ],
//            "lc":[
//               "69",
//               "69",
//               "69",
//               "69",
//               "69",
//               "69",
//               "69",
//               "69",
//               "69",
//               "69",
//               "69",
//               "69",
//               "69"
//            ]
//         }
//      ]
//   ]
//]
//
public typealias GoogleInputResult = Result<GoogleInputResponse, Error>

public struct GoogleInputResponse: Decodable {

    enum CodingKeys: String, CodingKey {
        case annotation
        case languageCode = "lc"
        case matchLength = "matched_length"
    }

    public enum Status: String {
        case success = "SUCCESS"
        case failedToParseRequestBody = "FAILED_TO_PARSE_REQUEST_BODY"
        case unknown
    }

    public struct Suggestion: Decodable {
        public let word: String
        public let matchedLength: Int
        public let annotation: String
        public let languageCode: String
    }

    public let status: Status
    public let input: String
    public let suggestions: [Suggestion]

    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let status = try container.decode(String.self)
        if status != Status.success.rawValue {
            self.status = Status(rawValue: status) ?? Status.unknown
            self.input = ""
            self.suggestions = []
            return
        }
        var arrayContainer = try container.nestedUnkeyedContainer()
        var arrayContainer2 = try arrayContainer.nestedUnkeyedContainer()
        let input = try arrayContainer2.decode(String.self)
        let words = try arrayContainer2.decode([String].self)
        _ = try arrayContainer2.decode([String].self)
        let keyedContainer = try arrayContainer2.nestedContainer(keyedBy: CodingKeys.self)
        let annotations = try keyedContainer.decode([String].self, forKey: .annotation)
        let languageCodes = try keyedContainer.decode([String].self, forKey: .languageCode)
        let matchedLengths = try? keyedContainer.decode([Int].self, forKey: .matchLength)
        var suggestions: [Suggestion] = []
        for (index, word) in words.enumerated() {
            let suggestion = Suggestion(word: word,
                                        matchedLength: matchedLengths?[index] ?? input.count,
                                        annotation: annotations[index],
                                        languageCode: languageCodes[index])
            suggestions.append(suggestion)
        }
        self.status = Status.success
        self.input = input
        self.suggestions = suggestions
    }
}
