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
        func parse2GetIdTitleUrl(ele: Element) throws -> (String, String, String) {
            let title = try ele.text()
            let url = try ele.getElementsByTag("a").first()!.attr("href")
            let start = url.index(after: url.lastIndex(of: "/")!)
            let end = url.firstIndex(of: "#")!
            let id = String(url[start..<end])
            return (id, title, url)
        }

        func parse2GetNodeLastTouchedLastReplyBy(ele: Element) throws -> (Node, String, Member?) {
            let aEles = try ele.getElementsByTag("a")
            let aEle = aEles[0]
            let nodeTitle = try aEle.text()
            let nodeUrl = try aEle.attr("href")
            let nodeName = String(nodeUrl.suffix(from: nodeUrl.index(after: nodeUrl.lastIndex(of: "/")!)))
            let node = Node(title: nodeTitle, url: nodeUrl, name: nodeName)
            let lastTouched = try ele.getElementsByTag("span").first()!.text()
            .split(separator: "•")[2].trimmingCharacters(in: .whitespaces)

            var lastReplyBy: Member?

            if aEles.size() == 3 {
                let aEle1 = aEles[2]
                lastReplyBy = Member(url: try aEle1.attr("href"), name: try aEle1.text(), avatar: nil)
            }
            return (node, lastTouched, lastReplyBy)
        }

        func parse2GetMember(ele: Element) throws -> Member {
            let imageEle = try ele.getElementsByTag("img").first()!
            let url = try ele.attr("href")
            let name = try imageEle.attr("alt")
            let avatar = try imageEle.attr("src")
            return Member(url: url, name: name, avatar: avatar)
        }

        var topics: [Topic] = []
        let doc = try SwiftSoup.parse(html)
        let itemEles = try doc.select("#Main .item")
        for itemEle in itemEles {
            let (id, title, url) = try parse2GetIdTitleUrl(ele: try itemEle.getElementsByClass("item_title").first()!)
            let member = try parse2GetMember(ele: try itemEle.getElementsByTag("a").first()!)
            let (node, lastTouched, lastReplyBy) = try parse2GetNodeLastTouchedLastReplyBy(ele: try itemEle.getElementsByClass("topic_info").first()!)
            let replyCount = Int(try itemEle.getElementsByClass("count_livid").first()?.text() ?? "0") ?? 0
            topics.append(Topic(id: id, node: node, member: member, title: title, content: nil,
                    url: url, replyCount: replyCount, createTime: nil, lastReplyBy: lastReplyBy, lastTouched: lastTouched, pageCount: nil))
        }
        return topics
    }

    func parse2TopicReplies(html: String, id: String) throws -> (Topic, [Reply]) {
        let doc = try SwiftSoup.parse(html)
        let mainEle = try doc.getElementById("Main")!
        let contentEle = try mainEle.getElementsByClass("box").first()!
        let header = try contentEle.getElementsByClass("header").first()!

        let nodeAEle = try header.getElementsByTag("a")[2]
        let node = Node(title: try nodeAEle.text(), url: try nodeAEle.attr("href"), name: "")

        let title = try header.getElementsByTag("h1").first()!.text()
        let memberAEle = try header.select("small > a").first()!
        let memeber = Member(url: try memberAEle.attr("href"), name: try memberAEle.text(), avatar: nil)
        let createTime = try header.select("small > span").text()

        let content = try contentEle.getElementsByClass("topic_content").first()!.outerHtml()

        let pageCount = Int(try mainEle.getElementsByClass("page_input").first()?.attr("max") ?? "0")!

        return (Topic(id: id, node: node, member: memeber, title: title, content: content, url: nil, replyCount: nil, createTime: createTime,
                lastReplyBy: nil, lastTouched: nil, pageCount: pageCount), try parse2Replies(doc: doc))
    }

    func parseJson2SimpleTopics(json: String) throws -> [Topic] {
        let array = JSON(parseJSON: json)
        var topics: [Topic] = []
        for (_, obj) in array {
            let nodeObj = obj["node"]
            let node = Node(title: nodeObj["title"].stringValue, url: nodeObj["url"].stringValue, name: nodeObj["name"].stringValue)
            let memberObj = obj["member"]
            let member = Member(url: memberObj["url"].stringValue, name: memberObj["username"].stringValue, avatar: memberObj["avatar_large"].stringValue)
            var lastReplyBy: Member?
            if let username = obj["last_reply_by"].string, !username.isEmpty {
                lastReplyBy = Member(name: username)
            }
            let lastTouched = timestamp2Date(timestamp: obj["last_touched"].int64Value)
            let title = obj["title"].stringValue
            let url = obj["url"].stringValue
            let replyCount = obj["replies"].intValue
            let id = obj["id"].stringValue
            topics.append(Topic(id: id, node: node, member: member, title: title, content: nil, url: url, replyCount: replyCount,
                    createTime: nil, lastReplyBy: lastReplyBy, lastTouched: lastTouched, pageCount: nil))
        }
        return topics
    }

    func parse2Replies(html: String) throws -> [Reply] {
        let doc = try SwiftSoup.parse(html)
        return try parse2Replies(doc: doc)
    }

    func parse2Replies(doc: Document) throws -> [Reply] {
        let count = try doc.select("#Main > .box").count
        let cellEles = try doc.select("#Main > .box")[1].getElementsByClass("cell")
        var replies: [Reply] = []
        for cellEle in cellEles {
            if cellEle.hasAttr("id") {
                let idStr = try cellEle.attr("id")
                let id = String(idStr.suffix(from: idStr.index(idStr.startIndex, offsetBy: 2)))
                let imgEle = try cellEle.select("table > tbody > tr > td:nth-child(1) > img").first()!
                let avatar = try imgEle.attr("src")
                let aEle = try cellEle.select("table > tbody > tr > td:nth-child(3) > strong > a").first()!
                let name = try aEle.text()
                let url = try aEle.attr("href")
                let member = Member(url: url, name: name, avatar: avatar)
                let createTime = try cellEle.select(".ago").first()!.text()
                let content = try cellEle.select(".reply_content").first()!.outerHtml()
                let thankCount = try cellEle.select(".fade").first()?.text() ?? ""
                let floor = try cellEle.select(".no").first()!.text()
                let reply = Reply(member: member, creatTime: createTime, content: content, id: id)
                replies.append(reply)
            }
        }
        return replies
    }

    func parse2NodeMap(doc: Document) throws -> [String: [Node]] {
        let eles = try doc.select("table")
        var map: [String: [Node]] = [:]
        for ele in eles {
            let navNode = try ele.select("tbody > tr > td:nth-child(1)").text()
            let aEles = try ele.select("tbody > tr > td:nth-child(2) > a")
            var nodes: [Node] = []
            for aEle in aEles {
                let url = try aEle.attr("href")
                let name = String(url.suffix(from: url.index(after: url.lastIndex(of: "/")!)))
                let title = try aEle.text()
                let node = Node(title: title, url: url, name: name)
                nodes.append(node)
            }
            map[navNode] = nodes
        }
        return map
    }

    private func timestamp2Date(timestamp: Int64) -> String {
        var timeStr: String = ""
        let duration = Int64(Date.now.timeIntervalSince1970) - timestamp
        switch duration {
        case 1...10: timeStr = "几秒前"
        case 11...20: timeStr = "十几秒前"
        case 21...60: timeStr = "几十秒前"
        case 61...600: timeStr = "几分钟前"
        case 601...1200: timeStr = "十几分钟前"
        case 1201...3600: timeStr = "几十分钟前"
        case 3601...7200: timeStr = "一个小时前"
        case 7201...14400: timeStr = "几个小时前"
        case 14400...43200: timeStr = "十几小时前"
        case 43201...86400: timeStr = "一天前"
        default:
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            timeStr = formatter.string(from: Date(timeIntervalSince1970: Double(timestamp)))
        }
        return timeStr
    }
}
