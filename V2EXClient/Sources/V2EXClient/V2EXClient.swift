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

    // DEBUG
    public func getJsonTopics() async throws -> [Topic] {
        try parser.parseJson2SimpleTopics(json: debugTopicsJson)
    }

    // DEBUG
    public func getHtmlTopics() async throws -> [Topic] {
        return try parser.parse2SimpleTopics(html: debugTopicsHtml)
    }

    // DEBUG
    public func getHtmlTopic() async throws -> (Topic, [Reply]) {
        return try parser.parse2TopicReplies(html: debugTopicHtml, id: "845141")
    }

    // 获取最新话题
    public func getLatestTopics() async throws -> [Topic] {
        let topicsJson = try await doGetTopicsJson(urlStr: "https://www.v2ex.com/api/topics/latest.json?time=")
        return try parser.parseJson2SimpleTopics(json: topicsJson)
    }

    // 获取最热话题
    public func getHottestTopics() async throws -> [Topic] {
        let html = try await doGetTopicsHtml(url: "https://v2ex.com/?tab=hot")
        return try parser.parse2SimpleTopics(html: html)
    }

    // 获取全部 Tab 的话题
    public func getAllTabTopics() async throws -> [Topic] {
        let html = try await doGetTopicsHtml(url: "https://v2ex.com/?tab=all")
        return try parser.parse2SimpleTopics(html: html)
    }

    // 获取技术 Tab 的话题
    public func getTechTabTopics() async throws -> [Topic] {
        let html = try await doGetTopicsHtml(url: "https://v2ex.com/?tab=tech")
        return try parser.parse2SimpleTopics(html: html)
    }

    // 获取创意 Tab 的话题
    public func getCreativeTabTopics() async throws -> [Topic] {
        let html = try await doGetTopicsHtml(url: "https://v2ex.com/?tab=creative")
        return try parser.parse2SimpleTopics(html: html)
    }

    // 获取好玩 Tab 的话题
    public func getPlayTabTopics() async throws -> [Topic] {
        let html = try await doGetTopicsHtml(url: "https://v2ex.com/?tab=play")
        return try parser.parse2SimpleTopics(html: html)
    }

    // 获取 Apple Tab 的话题
    public func getAppleTabTopics() async throws -> [Topic] {
        let html = try await doGetTopicsHtml(url: "https://v2ex.com/?tab=apple")
        return try parser.parse2SimpleTopics(html: html)
    }

    // 获取酷工作 Tab 的话题
    public func getJobsTabTopics() async throws -> [Topic] {
        let html = try await doGetTopicsHtml(url: "https://v2ex.com/?tab=jobs")
        return try parser.parse2SimpleTopics(html: html)
    }

    // 获取交易 Tab 的话题
    public func getDealsTabTopics() async throws -> [Topic] {
        let html = try await doGetTopicsHtml(url: "https://v2ex.com/?tab=deals")
        return try parser.parse2SimpleTopics(html: html)
    }

    // 获取城市 Tab 的话题
    public func getCityTabTopics() async throws -> [Topic] {
        let html = try await doGetTopicsHtml(url: "https://v2ex.com/?tab=city")
        return try parser.parse2SimpleTopics(html: html)
    }

    // 获取问与答 Tab 的话题
    public func getQnaTabTopics() async throws -> [Topic] {
        let html = try await doGetTopicsHtml(url: "https://v2ex.com/?tab=qna")
        return try parser.parse2SimpleTopics(html: html)
    }

    // 获取节点 Tab 的话题
    public func getNodesTabTopics() async throws -> [Topic] {
        let html = try await doGetTopicsHtml(url: "https://v2ex.com/?tab=nodes")
        return try parser.parse2SimpleTopics(html: html)
    }

    // 获取节点导航数据
    public func getNavNodeMap() async throws -> [String: [Node]] {
        let doc = try SwiftSoup.parse(nodesHtml)
        return try parser.parse2NodeMap(doc: doc)
    }

    public func getNodeTopics(url: String) async throws -> (Node, [Topic]) {
        let doc = try await doGetNodeHtml(url: url)
        return []
    }

    // 获取话题详情和第一页评论
    public func getTopicReplies(id: String) async throws -> (Topic, [Reply]) {
        let html = try await doGetTopicHtml(url: "https://v2ex.com/t/\(id)")
        return try parser.parse2TopicReplies(html: html, id: id)
    }

    public func getRepliesByTopic(id: String, p: Int) async throws -> [Reply] {
        let html = try await doGetTopicHtml(url: "https://v2ex.com/t/\(id)?p=\(p)")
        return try parser.parse2Replies(html: html)
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

    private func doGetNodeHtml(url:String) async throws -> String {
        let (data, _) = try await urlSession.data(from: URL(string: url)!)
        return String(data: data, encoding: .utf8)!
    }

}
