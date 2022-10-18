import Foundation
import SwiftSoup
import SwiftyJSON

public class V2EXClient {
    public static let shared = V2EXClient()

    private let parser = Parser()
    private let urlSession: URLSession

    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 5
        urlSession = URLSession(configuration: config)
    }

    // ========

    // 获取最新话题
    public func getLatestTopics() async throws -> [Topic] {
        #if DEBUG
            return try parser.parse2SimpleTopics(html: debugTopicsHtml)
        #else
            let topicsJson = try await doGetTopicsJson(urlStr: "https://www.v2ex.com/api/topics/latest.json?time=")
            return try parser.parseJson2SimpleTopics(json: topicsJson)
        #endif
    }

    // 获取最热话题
    public func getHottestTopics() async throws -> [Topic] {
        #if DEBUG
            return try parser.parse2SimpleTopics(html: debugTopicsHtml)
        #else
            return try await getTopicsByTab(tab: "hot")
        #endif
    }

    // 获取对应 Tab 下的话题
    public func getTopicsByTab(tab: String?) async throws -> [Topic] {
        if let tab {
            let html = try await doGetTopicsHtml(url: "https://v2ex.com/?tab=\(tab)")
            return try parser.parse2SimpleTopics(html: html)
        } else {
            return try parser.parse2SimpleTopics(html: debugTopicsHtml)
        }
    }

    // 获取节点导航数据
    public func getNavigatinNodes() throws -> [String: [Node]] {
        let doc = try SwiftSoup.parse(nodesHtml)
        return try parser.parse2Nodes(doc: doc)
    }

    // 获取节点详情和主题
    public func getNodeTopics(node: Node) async throws -> (Node, [Topic]) {
        #if DEBUG
            return (Node.mock, try parser.parse2SimpleTopics(html: debugTopicsHtml))
        #else
            let doc = try await doGetNodeHtml(url: "https://v2ex.com\(node.url)")
            return try parser.parse2SimpleTopicsForNode(html: doc, node: node)
        #endif
    }

    // 获取话题详情和第一页评论
    public func getTopicReplies(id: String) async throws -> (Topic, [Reply]) {
        #if DEBUG
            return try parser.parse2TopicReplies(html: debugTopicHtml, id: "845141")
        #else
            let html = try await doGetTopicHtml(url: "https://v2ex.com/t/\(id)")
            return try parser.parse2TopicReplies(html: html, id: id)
        #endif
    }

    public func getRepliesByTopic(id: String, p: Int) async throws -> [Reply] {
        #if DEBUG
            return try parser.parse2TopicReplies(html: debugTopicHtml, id: "845141").1
        #else
            let html = try await doGetTopicHtml(url: "https://v2ex.com/t/\(id)?p=\(p)")
            return try parser.parse2Replies(html: html)
        #endif
    }

    private func doGetTopicsHtml(url: String) async throws -> String {
        let (data, _) = try await urlSession.data(from: URL(string: url)!)
        return String(data: data, encoding: .utf8)!
    }

    private func doGetTopicHtml(url: String) async throws -> String {
        let (data, _) = try await urlSession.data(from: URL(string: url)!)
        return String(data: data, encoding: .utf8)!
    }

    private func doGetTopicsJson(urlStr: String) async throws -> String {
        let url = URL(string: urlStr + String(Date().timeIntervalSince1970))!
        let (data, _) = try await urlSession.data(from: url)
        return String(data: data, encoding: .utf8)!
    }

    private func doGetNodeHtml(url: String) async throws -> String {
        let (data, _) = try await urlSession.data(from: URL(string: url)!)
        return String(data: data, encoding: .utf8)!
    }
}
