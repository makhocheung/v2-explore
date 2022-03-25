@testable import V2EXClient
import XCTest

@available(macOS 12, *)
final class V2EXClientTests: XCTestCase {
    func testExample() async throws {
//        let tabAll = try! String(contentsOfFile: "/Users/makho-cheung/Library/Application Support/JetBrains/IntelliJIdea2021.3/scratches/scratch.html")
//        let doc: Document = try! SwiftSoup.parse(tabAll)
//        let mainEle = try! doc.select("#Main > .box")[0]
//        let item = try mainEle.getElementsByClass("item")[0]
//        let topic = try V2EXClient().parse2BriefTopic(ele: item)
//        print(topic)
        print(try await V2EXClient.shared.getHtmlTopic().1)
    }
}
