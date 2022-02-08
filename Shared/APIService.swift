//
//  APIService.swift
//  V2EX You
//
//  Created by Mak Ho-Cheung on 2022/2/12.
//

import Foundation

class APIService {
    static let shared = APIService()

    func getTopics(_ preferNode: PreferNode) async throws -> [Topic] {
        switch preferNode {
        case .latestPreferNode:
            let url = URL(string: "https://www.v2ex.com/api/topics/latest.json?time=\(Date().timeIntervalSince1970)")!
            let (data, _) = try await URLSession.shared.data(from: url)
            return try JSONDecoder().decode([Topic].self, from: data)
        case .hotPreferNode:
            let url = URL(string: "https://www.v2ex.com/api/topics/hot.json?time=\(Date().timeIntervalSince1970)")!
            let (data, _) = try await URLSession.shared.data(from: url)
            return try JSONDecoder().decode([Topic].self, from: data)
        default:
            let url = URL(string: "https://www.v2ex.com/api/topics/show.json?node_id=\(preferNode.id)&time=\(Date().timeIntervalSince1970)")!
            let (data, _) = try await URLSession.shared.data(from: url)
            return try JSONDecoder().decode([Topic].self, from: data)
        }
    }
}
