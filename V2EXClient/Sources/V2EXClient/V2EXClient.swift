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

    public func getLatestTopicsForDebug() throws -> [Topic] {
        return try parser.parse2SimpleTopics(html: debugTopicsHtml)
    }

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

    public func getCaptchaUrl() -> URL {
        let timestamp = Int(Date.now.timeIntervalSince1970 * 1000)
        return URL(string: "https://v2ex.com/_captcha?now=\(timestamp)")!
    }

    public func getPreSignIn() async throws -> PreSignIn {
        let (data, _) = try await urlSession.data(from: URL(string: "https://v2ex.com/signin")!)
        return try parser.parse2PreSignIn(html: String(data: data, encoding: .utf8)!)
    }

    public func signIn(signIn: SignIn) async throws -> (User, Token) {
        HTTPCookieStorage.shared.cookies?.filter { $0.domain.contains("v2ex.com") && $0.name == "A2" }.forEach {
            HTTPCookieStorage.shared.deleteCookie($0)
        }
        let url = URL(string: "https://v2ex.com/signin")!
        var request = URLRequest(url: url)
        request.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.1 Safari/605.1.15", forHTTPHeaderField: "User-Agent")
        request.setValue("https://v2ex.com/signin", forHTTPHeaderField: "Referer")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let encodedUsername = signIn.username.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let encodedPassword = signIn.password.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let body = "\(signIn.usernameKey)=\(encodedUsername)&\(signIn.passwordKey)=\(encodedPassword)&\(signIn.captchaKey)=\(signIn.captcha)&once=\(signIn.once)&next=/"
        request.httpBody = body.data(using: .utf8)
        let (data, _) = try await urlSession.data(for: request)
        if let user = try parser.parse2User(html: String(data: data, encoding: .utf8)!) {
            let a2Cookie = HTTPCookieStorage.shared.cookies?.filter {
                $0.domain.contains("v2ex") && $0.name == "A2"
            }.first
            guard let a2Cookie else {
                throw V2EXClientError.loginFailed
            }
            return (user, Token(a2: a2Cookie.value, a2ExpireDate: a2Cookie.expiresDate!))
        } else {
            throw V2EXClientError.loginFailed
        }
    }

    public func isSignIn() async throws -> User? {
        let (data, _) = try await urlSession.data(from: URL(string: "https://v2ex.com")!)
        let html = String(data: data, encoding: .utf8)!
        return try parser.parse2User(html: html)
    }

    public func getUserProfile(name: String, useHomeData: Bool = false) async throws -> User {
        if useHomeData {
            async let (homeData, _) = try urlSession.data(from: URL(string: "https://v2ex.com")!)
            async let (detailData, _) = try urlSession.data(from: URL(string: "https://v2ex.com/member/\(name)")!)
            let homeHtml = try await String(data: homeData, encoding: .utf8)!
            let detailHtml = try await String(data: detailData, encoding: .utf8)!
            let userFromHome = try parser.parse2UserFromHome(html: homeHtml)
            let userFromDetail = try parser.parse2UserFromDetail(html: detailHtml)
            if let userFromHome {
                return User.merge(l: userFromHome, r: userFromDetail)
            } else {
                return userFromDetail
            }
        } else {
            let (detailData, _) = try await urlSession.data(from: URL(string: "https://v2ex.com/member/\(name)")!)
            let detailHtml = String(data: detailData, encoding: .utf8)!
            return try parser.parse2UserFromDetail(html: detailHtml)
        }
        
    }

    private func doGetTopicsHtml(url: String) async throws -> String {
        let (data, _) = try await urlSession.data(from: URL(string: url)!)
        return String(data: data, encoding: .utf8)!
    }

    private func doGetTopicHtml(url: String) async throws -> String {
        let (data, response) = try await urlSession.data(from: URL(string: url)!)
        guard let response = response as? HTTPURLResponse else {
            fatalError("不可能错误")
        }
        if response.statusCode == 404 {
            throw V2EXClientError.unavailable
        }
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
