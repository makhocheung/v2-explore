//
//  APIService.swift
//  V2EX You
//
//  Created by Mak Ho-Cheung on 2022/2/12.
//

import Foundation
import V2EXClient

class APIService {
    static let shared = APIService()

    private let urlSession: URLSession

    init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 5
        urlSession = URLSession(configuration: config)
    }

    func getLatestTopics() async throws -> [Topic] {
        try await doGetTopics(urlStr: "https://www.v2ex.com/api/topics/latest.json?time=")
    }

    func getHottestTopics() async throws -> [Topic] {
        try await doGetTopics(urlStr: "https://www.v2ex.com/api/topics/hot.json?time=")
    }

    func getTopicsByNode(nodeName: String) async throws -> [Topic] {
        try await doGetTopics(urlStr: "https://www.v2ex.com/api/topics/show.json?node_name=\(nodeName)&time=")
    }

    func getRepliesByTopic(topicId: Int) async throws -> [Reply] {
        let url = URL(string: "https://www.v2ex.com/api/replies/show.json?topic_id=\(topicId)&time=\(Date().timeIntervalSince1970)")!
        let (data, _) = try await urlSession.data(from: url)
        return try jsonDecoder.decode([Reply].self, from: data)
    }

    private func doGetTopics(urlStr: String) async throws -> [Topic] {
        let url = URL(string: urlStr + String(Date().timeIntervalSince1970))!
        let (data, _) = try await urlSession.data(from: url)
        return try jsonDecoder.decode([Topic].self, from: data)
    }
}
