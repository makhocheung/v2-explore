import SwiftSoup
import SwiftyJSON
@testable import V2EXClient
import XCTest

@available(macOS 12, *)
final class V2EXClientTests: XCTestCase {
    func testExample() async throws {
        let v2exBundleUrl = Bundle.module.resourceURL!.appendingPathComponent("V2EXClient", conformingTo: .bundle).appendingPathExtension("bundle")
        let v2exBundle = Bundle(url: v2exBundleUrl)!
        let htmlUrl = v2exBundle.resourceURL!.appendingPathComponent("DebugNodeTopics", conformingTo: .html)
        let data = try! String(contentsOf: htmlUrl)
        let parser = Parser()
        do {
            let (node, topics) = try parser.parse2SimpleTopicsForNode(html: data, node: Node(title: "Java", url: "java", name: "Java"))
            print(node.desc)
        } catch {
            print(error)
        }
    }
}
