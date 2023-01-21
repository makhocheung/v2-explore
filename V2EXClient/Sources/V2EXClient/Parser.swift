//
//  File.swift
//
//
//  Created by Mak Ho-Cheung on 2022/3/27.
//

import Foundation
import SwiftSoup
import SwiftyJSON

class Parser {
    func parse2SimpleTopics(html: String) throws -> [Topic] {
        var topics: [Topic] = []
        let doc = try SwiftSoup.parse(html)
        let itemElements = try doc.select("#Main .item")
        for itemElement in itemElements {
            let (id, title, url) = try parse2GetIdTitleUrl(element: try itemElement.getElementsByClass("item_title").first()!)
            let member = try parse2GetMember(ele: try itemElement.getElementsByTag("a").first()!)
            let (node, createTime, lastTouched, lastReplyBy) = try parse2GetNodeCreateTimeLastTouchedLastReplyBy(element: try itemElement.getElementsByClass("topic_info").first()!)
            var replyCount = 0
            if let countElement = try itemElement.getElementsByClass("count_livid").first() {
                replyCount = Int(try countElement.text()) ?? 0
            } else {
                if let countOrangeElement = try itemElement.getElementsByClass("count_orange").first() {
                    replyCount = Int(try countOrangeElement.text()) ?? 0
                }
            }
            topics.append(Topic(id: id, node: node, member: member, title: title, content: nil,
                                url: url, replyCount: replyCount, createTime: createTime, lastReplyBy: lastReplyBy, lastTouched: lastTouched, pageCount: nil))
        }
        return topics
    }

    func parseJson2SimpleTopics(json: String) throws -> [Topic] {
        let JsonArray = JSON(parseJSON: json)
        var topics: [Topic] = []
        for (_, jsonObj) in JsonArray {
            let nodeJsonObj = jsonObj["node"]
            let node = Node(title: nodeJsonObj["title"].stringValue, url: nodeJsonObj["url"].stringValue, name: nodeJsonObj["name"].stringValue)
            let memberObj = jsonObj["member"]
            let member = Member(name: memberObj["username"].stringValue, url: memberObj["url"].stringValue, avatar: memberObj["avatar_large"].stringValue)
            var lastReplyBy: Member?
            if let username = jsonObj["last_reply_by"].string, !username.isEmpty {
                lastReplyBy = Member(name: username)
            }
            let lastTouched = timestamp2Date(timestamp: jsonObj["last_touched"].int64Value)
            let createTime = timestamp2Date(timestamp: jsonObj["created"].int64Value)
            let title = jsonObj["title"].stringValue
            let url = jsonObj["url"].stringValue
            let replyCount = jsonObj["replies"].intValue
            let id = jsonObj["id"].stringValue
            topics.append(Topic(id: id, node: node, member: member, title: title, content: nil, url: url, replyCount: replyCount,
                                createTime: createTime, lastReplyBy: lastReplyBy, lastTouched: lastTouched, pageCount: nil))
        }
        return topics
    }

    func parse2SimpleTopicsForNode(html: String, node: Node) throws -> (Node, [Topic]) {
        var topics: [Topic] = []
        let doc = try SwiftSoup.parse(html)
        let nodeHeaderElement = try doc.select("#Main .node-header").first()!
        let avatar = try nodeHeaderElement.getElementsByTag("img").first()!.attr("src")
        let count = try nodeHeaderElement.getElementsByClass("topic-count").first()!.getElementsByTag("strong").first()!.text()
        let desc = try nodeHeaderElement.getElementsByClass("intro").first()?.text()
        let cellElements = try doc.select("#TopicsNode .cell")
        for cellElement in cellElements {
            let (id, title, url) = try parse2GetIdTitleUrl(element: try cellElement.getElementsByClass("item_title").first()!)
            let member = try parse2GetMember(ele: try cellElement.getElementsByTag("a").first()!)
            let (createTime, lastTouched, lastReplyBy) = try parse2GetCreateTimeLastTouchedLastReplyBy(element: try cellElement.getElementsByClass("topic_info").first()!)
            let replyCount = Int(try cellElement.getElementsByClass("count_livid").first()?.text() ?? "0") ?? 0
            topics.append(Topic(id: id, node: node, member: member, title: title, content: nil,
                                url: url, replyCount: replyCount, createTime: createTime, lastReplyBy: lastReplyBy, lastTouched: lastTouched, pageCount: nil))
        }
        return (Node(title: node.title, url: node.url, name: node.name, parentNodeName: node.parentNodeName, avatar: avatar, desc: desc, count: Int(count)), topics)
    }

    func parse2TopicReplies(html: String, id: String) throws -> (Topic, [Reply]) {
        let doc = try SwiftSoup.parse(html)
        let mainElement = try doc.getElementById("Main")!
        let boxElement = try mainElement.getElementsByClass("box").first()!
        let headerElement = try boxElement.getElementsByClass("header").first()!
        let nodeElement = try headerElement.getElementsByTag("a")[2]
        let node = Node(title: try nodeElement.text(), url: try nodeElement.attr("href"), name: "")
        let title = try headerElement.getElementsByTag("h1").first()!.text()
        let memberElement = try headerElement.select("small > a").first()!
        let member = Member(name: try memberElement.text(), url: try memberElement.attr("href"), avatar: try headerElement.getElementsByTag("img").first()!.attr("src"))
        let createTime = try headerElement.select("small > span").text()
        let pageCount = Int(try mainElement.getElementsByClass("page_input").first()?.attr("max") ?? "0")!
        let markdownBodyElement = try boxElement.getElementsByClass("markdown_body").first()
        let topicContentElement = try boxElement.getElementsByClass("topic_content").first()
        var topicContentSections: [ContentSection] = []
        var content: String?
        if let markdownBodyElement {
            content = try markdownBodyElement.outerHtml()
            if markdownBodyElement.children().isEmpty() {
                topicContentSections.append(ContentSection(type: .literal, content: try parse2AttributeString(string: "<p>\(markdownBodyElement.text())</p>")))
            } else {
                for it in markdownBodyElement.children() {
                    let imgElements = try it.getElementsByTag("img")
                    if !imgElements.isEmpty() {
                        for imgElement in imgElements {
                            // todo 图片是超链接
                            topicContentSections.append(ContentSection(type: .image, content: try imgElement.attr("src")))
                        }
                        continue
                    }
                    let codeElements = try it.select("pre > code")
                    if !codeElements.isEmpty() {
                        topicContentSections.append(ContentSection(type: .code, content: try parse2AttributeString(string: it.outerHtml())))
                        continue
                    }
                    topicContentSections.append(ContentSection(type: .literal, content: try parse2AttributeString(string: it.outerHtml())))
                }
            }
        } else if let topicContentElement {
            // TODO: 非 MD 内容优化
            content = try topicContentElement.outerHtml()
            topicContentSections.append(ContentSection(type: .literal, content: try parse2AttributeString(string: content!)))
        }

        let (replies, nextPage) = try parse2Replies(doc: doc)
        return (Topic(id: id, node: node, member: member, title: title, content: content, url: nil, replyCount: nil, createTime: createTime,
                      lastReplyBy: nil, lastTouched: nil, pageCount: pageCount, contentSections: topicContentSections, nextPage: nextPage), replies)
    }

    func parse2Replies(html: String) throws -> ([Reply], Int?) {
        let doc = try SwiftSoup.parse(html)
        return try parse2Replies(doc: doc)
    }

    func parse2Replies(doc: Document) throws -> ([Reply], Int?) {
        var replies: [Reply] = []
        let boxElements = try doc.select("#Main > .box")
        guard boxElements.size() > 1 else {
            return (replies, nil)
        }
        let cellElements = try boxElements[1].getElementsByClass("cell")
        for cellElement in cellElements {
            if cellElement.hasAttr("id") {
                let originalId = try cellElement.attr("id")
                let id = String(originalId.suffix(from: originalId.index(originalId.startIndex, offsetBy: 2)))
                let imgElement = try cellElement.select("table > tbody > tr > td:nth-child(1) > img").first()!
                let avatar = try imgElement.attr("src")
                let memberElement = try cellElement.select("table > tbody > tr > td:nth-child(3) > strong > a").first()!
                let name = try memberElement.text()
                let url = try memberElement.attr("href")
                let member = Member(name: name, url: url, avatar: avatar)
                let createTime = try cellElement.select(".ago").first()!.text()
                let content = try cellElement.select(".reply_content").first()!.outerHtml()
                let thankCount = try cellElement.select(".fade").first()?.text() ?? "0"
                let floor = try cellElement.select(".no").first()!.text()
                let reply = Reply(id: id, content: content, attributeStringContent: try parse2AttributeString(string: content), member: member, creatTime: createTime,floor: floor, thankCount: Int(thankCount)!)
                replies.append(reply)
            }
        }
        var nextPage: Int?

        if let pageCurrentElement = try doc.getElementsByClass("page_current").first() {
            if let nextPageElement = try pageCurrentElement.nextElementSibling() {
                nextPage = Int(try nextPageElement.text().trimmingCharacters(in: .whitespaces))
            }
        }

        return (replies, nextPage)
    }

    func parse2Nodes(doc: Document) throws -> [String: [Node]] {
        let tableElements = try doc.select("table")
        var map: [String: [Node]] = [:]
        for tableElement in tableElements {
            let nodesTitle = try tableElement.select("tbody > tr > td:nth-child(1)").text()
            let nodesElements = try tableElement.select("tbody > tr > td:nth-child(2) > a")
            var nodes: [Node] = []
            for nodeElement in nodesElements {
                let url = try nodeElement.attr("href")
                let name = String(url.suffix(from: url.index(after: url.lastIndex(of: "/")!)))
                let title = try nodeElement.text()
                let node = Node(title: title, url: url, name: name)
                nodes.append(node)
            }
            map[nodesTitle] = nodes
        }
        return map
    }

    func parse2PreSignIn(html: String) throws -> PreSignIn {
        let doc = try SwiftSoup.parse(html)
        let trs = try doc.select("form > table tr")
        let usernameTr = trs[0]
        let passwordTr = trs[1]
        let captchaTr = trs[2]
        let onceTr = trs[3]
        let usernameKey = try usernameTr.getElementsByTag("input").first()!.attr("name")
        let passwordKey = try passwordTr.getElementsByTag("input").first()!.attr("name")
        let captchaKey = try captchaTr.getElementsByTag("input").first()!.attr("name")
        let once = try onceTr.getElementsByTag("input").first()!.attr("value")
        return PreSignIn(usernameKey: usernameKey, passwordKey: passwordKey, captchaKey: captchaKey, once: once)
    }

    func parse2User(html: String) throws -> User? {
        let doc = try SwiftSoup.parse(html)
        guard let userTable = try doc.getElementById("Rightbar")?.getElementsByClass("box").first()?.getElementsByClass("cell").first()?.getElementsByTag("table").first() else {
            return nil
        }
        let aElements = try userTable.getElementsByTag("a")
        let avatar = try aElements[0].getElementsByTag("img").first()!.attr("src")
        let name = try aElements[2].text()
        return User(name: name, avatar: avatar)
    }

    func parse2UserFromHome(html: String) throws -> User? {
        let doc = try SwiftSoup.parse(html)
        let tables = try doc.getElementById("Rightbar")?.getElementsByClass("box").first()?.getElementsByClass("cell").first()?.getElementsByTag("table")
        let flag = !(tables?.isEmpty() ?? true)
        guard flag else {
            return nil
        }
        let userTable = tables![0]
        let countTable = tables![1]
        let aElements = try userTable.getElementsByTag("a")
        let avatar = try aElements[0].getElementsByTag("img").first()!.attr("src")
        let name = try aElements[2].text()
        let tdElements = try countTable.getElementsByTag("td")
        let favoriteNodeCount = Int(try tdElements[0].getElementsByTag("span").first()?.text() ?? "")
        let favoriteTopicCount = Int(try tdElements[1].getElementsByTag("span").first()?.text() ?? "")
        let followerCount = Int(try tdElements[2].getElementsByTag("span").first()?.text() ?? "")
        let moneyElement = try doc.getElementById("money")
        let notificationElement = try moneyElement?.previousElementSibling()!
        let notificationCountStr = (try notificationElement?.text().split(separator: " ").first)!
        let notificationCount = Int(String(notificationCountStr))
        let textNodes = (try moneyElement?.getElementsByTag("a").first()?.textNodes())!
        let siliverCount = Int(textNodes[0].text().trimmingCharacters(in: .whitespacesAndNewlines))
        let brozenCount = Int(textNodes[1].text().trimmingCharacters(in: .whitespacesAndNewlines))
        return User(name: name, avatar: avatar, favoriteNodeCount: favoriteNodeCount, favoriteTopicCount: favoriteTopicCount, followerCount: followerCount, notificationCount: notificationCount, silverCount: siliverCount, bronzeCount: brozenCount)
    }

    func parse2UserFromDetail(html: String) throws -> User {
        let doc = try SwiftSoup.parse(html)
        let userTable = (try doc.getElementById("Main")?.getElementsByClass("box").first()?.getElementsByClass("cell").first()?.getElementsByTag("table").first())!
        let avatar = try userTable.getElementsByTag("img").first()!.attr("src")
        let tdElement = try userTable.getElementsByTag("td")[2]
        let name = try tdElement.getElementsByTag("h1").first()!.text()
        let activityRankElement = try tdElement.getElementsByTag("a").first()
        let activityRank: Int?
        if let activityRankElement {
            activityRank = try Int(activityRankElement.text())
        } else {
            activityRank = nil
        }
        let memberDesc: String
        let spanElements = try tdElement.getElementsByTag("span")
        if spanElements.size() > 1 {
            memberDesc = spanElements[1].textNodes()[0].text()
        } else {
            memberDesc = spanElements[0].textNodes()[0].text()
        }
        return User(name: name, avatar: avatar, memberDesc: memberDesc, activityRank: activityRank)
    }
    
    func parse2Once(html: String) throws -> String {
        let doc = try SwiftSoup.parse(html)
        return try doc.body()!.text()
    }
    
    func parse2IDAfterPostTopic(html: String) throws -> String {
        let doc = try SwiftSoup.parse(html)
        let topicContentElement = try doc.getElementsByClass("topic_content")[1]
        return try topicContentElement.getElementsByTag("td")[1].text()
    }

    private func timestamp2Date(timestamp: Int64) -> String {
        var timeStr: String = ""
        let duration = Int64(Date.now.timeIntervalSince1970) - timestamp
        switch duration {
        case 1 ... 10: timeStr = "几秒前"
        case 11 ... 20: timeStr = "十几秒前"
        case 21 ... 60: timeStr = "几十秒前"
        case 61 ... 600: timeStr = "几分钟前"
        case 601 ... 1200: timeStr = "十几分钟前"
        case 1201 ... 3600: timeStr = "几十分钟前"
        case 3601 ... 7200: timeStr = "一个小时前"
        case 7201 ... 14400: timeStr = "几个小时前"
        case 14400 ... 43200: timeStr = "十几小时前"
        case 43201 ... 86400: timeStr = "一天前"
        default:
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            timeStr = formatter.string(from: Date(timeIntervalSince1970: Double(timestamp)))
        }
        return timeStr
    }

    // ===

    private func parse2GetIdTitleUrl(element: Element) throws -> (String, String, String) {
        let title = try element.text()
        let url = try element.getElementsByTag("a").first()!.attr("href")
        let start = url.index(after: url.lastIndex(of: "/")!)
        let end = url.firstIndex(of: "#")!
        let id = String(url[start ..< end])
        return (id, title, url)
    }

    /**
     <span class="topic_info">
        <div class="votes"></div>
        <a class="node" href="/go/k8s">Kubernetes</a> &nbsp;•&nbsp;
        <strong><a href="/member/balabalaguguji">balabalaguguji</a></strong> &nbsp;•&nbsp;
        <span title="2022-04-06 19:33:51 +08:00">1 小时 3 分钟前</span> &nbsp;•&nbsp; 最后回复来自
        <strong><a href="/member/suisetai">suisetai</a></strong>
     </span>
     */
    private func parse2GetNodeCreateTimeLastTouchedLastReplyBy(element: Element) throws -> (Node, String?, String?, Member?) {
        let aElements = try element.getElementsByTag("a")
        let nodeElement = aElements[0]
        let nodeTitle = try nodeElement.text()
        let nodeUrl = try nodeElement.attr("href")
        let nodeName = String(nodeUrl.suffix(from: nodeUrl.index(after: nodeUrl.lastIndex(of: "/")!)))
        let node = Node(title: nodeTitle, url: nodeUrl, name: nodeName)
        let time = try element.getElementsByTag("span").first()!.text()
            .split(separator: "•")[2].trimmingCharacters(in: .whitespaces)
        var lastReplyBy: Member?
        var createTime: String?
        var lastTouched: String?
        if aElements.size() == 3 {
            let memberElement = aElements[2]
            lastReplyBy = Member(name: try memberElement.text(), url: try memberElement.attr("href"), avatar: nil)
            lastTouched = time
        } else {
            createTime = time
        }
        return (node, createTime, lastTouched, lastReplyBy)
    }

    /**
     <span class="topic_info"><strong><a href="/member/yanhomlin">yanhomlin</a></strong> &nbsp;•&nbsp; <span
                                            title="2022-08-30 07:36:53 +08:00">6 小时 37 分钟前</span> &nbsp;•&nbsp; 最后回复来自 <strong><a
                                            href="/member/wm5d8b">wm5d8b</a></strong></span>
     */
    private func parse2GetCreateTimeLastTouchedLastReplyBy(element: Element) throws -> (String?, String?, Member?) {
        let time = try element.getElementsByTag("span").first()!.text()
            .split(separator: "•")[1].trimmingCharacters(in: .whitespaces)
        var createTime: String?
        var lastTouched: String?
        var lastReplyBy: Member?
        let aElements = try element.getElementsByTag("a")
        if aElements.count > 1 {
            let memberElement = aElements[1]
            lastReplyBy = Member(name: try memberElement.text(), url: try memberElement.attr("href"), avatar: nil)
            lastTouched = time
        } else {
            createTime = time
        }
        return (createTime, lastTouched, lastReplyBy)
    }

    private func parse2GetMember(ele: Element) throws -> Member? {
        if let imgElement = try ele.getElementsByTag("img").first() {
            let url = try ele.attr("href")
            let name = try imgElement.attr("alt")
            let avatar = try imgElement.attr("src")
            return Member(name: name, url: url, avatar: avatar)
        } else {
            return nil
        }
    }

    private func parse2AttributeString(string: String) throws -> AttributedString {
        let nsAttrString = try NSAttributedString(data: string.data(using: .utf8)!, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        var attrString = AttributedString(nsAttrString)
        attrString.font = .body
        attrString.foregroundColor = .primary
        for it in attrString.runs {
            if let _ = it.link {
                attrString[it.range].foregroundColor = .blue
            }
        }
        return attrString
    }
}
