//
//  Standard.swift
//  V2EX You (iOS)
//
//  Created by Mak Ho-Cheung on 2021/12/11.
//

import SwiftUI
import V2EXClient

let HOTTEST_NODES = ["programmer", "create", "share", "apple", "jobs", "all4all", "guangzhou", "qna"]
let jsonEncoder = JSONEncoder()
let jsonDecoder = JSONDecoder()
let htmlTemplate = try! String(contentsOf: Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "Data")!)
let htmlDarkTemplate = try! String(contentsOf: Bundle.main.url(forResource: "index_dark", withExtension: "html", subdirectory: "Data")!)
let nodesJson = try! String(contentsOf: Bundle.main.url(forResource: "nodes", withExtension: "json", subdirectory: "Data")!)
let nodes = try! jsonDecoder.decode([Node].self, from: nodesJson.data(using: .utf8)!)

// debugData
#if DEBUG
    let debugTopicsJson = try! String(contentsOf: Bundle.main.url(forResource: "topics", withExtension: "json", subdirectory: "Data")!)
    let debugTopics = try! jsonDecoder.decode([Topic].self, from: debugTopicsJson.data(using: .utf8)!)

    let debugTopicJson = try! String(contentsOf: Bundle.main.url(forResource: "topic", withExtension: "json", subdirectory: "Data")!)
    let debugTopic = try! jsonDecoder.decode(Topic.self, from: debugTopicJson.data(using: .utf8)!)

    let debugRepliesJson = try! String(contentsOf: Bundle.main.url(forResource: "replies", withExtension: "json", subdirectory: "Data")!)
    let debugReplies = try! jsonDecoder.decode([Reply].self, from: debugRepliesJson.data(using: .utf8)!)

    let debugReplyJson = try! String(contentsOf: Bundle.main.url(forResource: "reply", withExtension: "json", subdirectory: "Data")!)
    let debugReply = try! jsonDecoder.decode(Reply.self, from: debugReplyJson.data(using: .utf8)!)
#endif

extension View {
    func hidden(_ shouldHide: Bool) -> some View {
        opacity(shouldHide ? 0 : 1)
    }
}
