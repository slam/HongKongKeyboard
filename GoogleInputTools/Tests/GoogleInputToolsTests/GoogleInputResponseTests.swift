import Foundation
import GoogleInputTools
import Nimble
import Quick

let jsonResponseWithoutMatchedLength = """
[
  "SUCCESS",
  [
     [
        "ma",
        [
           "嗎",
           "馬",
           "買",
           "媽",
           "碼",
           "埋",
           "麻",
           "賣",
           "孖",
           "物",
           "嘛",
           "咪",
           "乜"
        ],
        [

        ],
        {
           "annotation":[
              "ma",
              "ma",
              "maai",
              "ma",
              "ma",
              "maai",
              "ma",
              "maai",
              "ma",
              "mat",
              "ma",
              "maai",
              "mat"
           ],
           "candidate_type":[
              0,
              0,
              0,
              0,
              0,
              0,
              0,
              0,
              0,
              0,
              0,
              0,
              0
           ],
           "lc":[
              "69",
              "69",
              "69",
              "69",
              "69",
              "69",
              "69",
              "69",
              "69",
              "69",
              "69",
              "69",
              "69"
           ]
        }
     ]
  ]
]
""".data(using: .utf8)

let jsonResponseWithMatchedLength = """
[
   "SUCCESS",
   [
      [
         "tamadik",
         [
            "他媽的",
            "他媽",
            "大馬",
            "他",
            "他嗎",
            "打麻",
            "她",
            "大罵",
            "大",
            "打",
            "太",
            "它",
            "得"
         ],
         [

         ],
         {
            "annotation":[
               "ta ma dik",
               "ta ma",
               "daai ma",
               "ta",
               "ta ma",
               "da ma",
               "ta",
               "daai ma",
               "daai",
               "da",
               "taai",
               "ta",
               "dak"
            ],
            "candidate_type":[
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0,
               0
            ],
            "lc":[
               "69 69 69",
               "69 69",
               "69 69",
               "69",
               "69 69",
               "69 69",
               "69",
               "69 69",
               "69",
               "69",
               "69",
               "69",
               "69"
            ],
            "matched_length":[
               7,
               4,
               4,
               2,
               4,
               4,
               2,
               4,
               2,
               2,
               2,
               2,
               2
            ]
         }
      ]
   ]
]
""".data(using: .utf8)

let jsonResponseWithError = """
[
   "FAILED_TO_PARSE_REQUEST_BODY"
]
""".data(using: .utf8)

let jsonResponseForC = """
["SUCCESS",[["c",[],[],{"candidate_type":[]}]]]
""".data(using: .utf8)

let jsonResponseEmpty = """
["SUCCESS",[]]
""".data(using: .utf8)

class GoogleInputResponseTests: QuickSpec {
    override func spec() {
        describe("Decoding") {
            it("can decode jsonWithoutMatchedLength") {
                let decoder = JSONDecoder()
                do {
                    let response = try decoder.decode(GoogleInputResponse.self,
                                                      from: jsonResponseWithoutMatchedLength!)
                    expect(response).toNot(beNil())
                    expect(response.status).to(equal(GoogleInputResponse.Status.success))
                    expect(response.input).to(equal("ma"))
                    expect(response.suggestions).to(haveCount(13))
                    expect(response.suggestions[0].word).to(equal("嗎"))
                    expect(response.suggestions[0].matchedLength).to(equal(2))
                    expect(response.suggestions[0].annotation).to(equal("ma"))
                    expect(response.suggestions[0].languageCode).to(equal("69"))
                    expect(response.suggestions[12].word).to(equal("乜"))
                    expect(response.suggestions[12].matchedLength).to(equal(2))
                    expect(response.suggestions[12].annotation).to(equal("mat"))
                    expect(response.suggestions[12].languageCode).to(equal("69"))
                } catch {
                    print(error.localizedDescription)
                    expect(false).to(equal(true))
                }
            }

            it("can decode jsonWithMatchedLength") {
                let decoder = JSONDecoder()
                do {
                    let response = try decoder.decode(GoogleInputResponse.self,
                                                      from: jsonResponseWithMatchedLength!)
                    expect(response).toNot(beNil())
                    expect(response.status).to(equal(GoogleInputResponse.Status.success))
                    expect(response.input).to(equal("tamadik"))
                    expect(response.suggestions).to(haveCount(13))
                    expect(response.suggestions[0].word).to(equal("他媽的"))
                    expect(response.suggestions[0].matchedLength).to(equal(7))
                    expect(response.suggestions[0].annotation).to(equal("ta ma dik"))
                    expect(response.suggestions[0].languageCode).to(equal("69 69 69"))
                    expect(response.suggestions[12].word).to(equal("得"))
                    expect(response.suggestions[12].matchedLength).to(equal(2))
                    expect(response.suggestions[12].annotation).to(equal("dak"))
                    expect(response.suggestions[12].languageCode).to(equal("69"))
                } catch {
                    print(error.localizedDescription)
                    expect(false).to(equal(true))
                }
            }

            it("can decode response for c") {
                let decoder = JSONDecoder()
                do {
                    let response = try decoder.decode(GoogleInputResponse.self,
                                                      from: jsonResponseForC!)
                    expect(response).toNot(beNil())
                    expect(response.status).to(equal(GoogleInputResponse.Status.success))
                    expect(response.input).to(equal("c"))
                } catch {
                    print(error.localizedDescription)
                    expect(false).to(equal(true))
                }
            }

            it("can decode empty success") {
                let decoder = JSONDecoder()
                do {
                    let response = try decoder.decode(GoogleInputResponse.self,
                                                      from: jsonResponseEmpty!)
                    expect(response).toNot(beNil())
                    expect(response.status).to(equal(GoogleInputResponse.Status.success))
                    expect(response.input).to(equal(""))
                } catch {
                    print(error.localizedDescription)
                    expect(false).to(equal(true))
                }
            }

            it("can handle failed to parse error") {
                let decoder = JSONDecoder()
                do {
                    let response = try decoder.decode(GoogleInputResponse.self,
                                                      from: jsonResponseWithError!)
                    expect(response).toNot(beNil())
                    expect(response.status).to(equal(GoogleInputResponse.Status.failedToParseRequestBody))
                } catch {
                    print(error.localizedDescription)
                    expect(false).to(equal(true))
                }
            }
        }
    }
}
