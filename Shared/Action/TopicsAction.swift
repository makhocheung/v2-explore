//
// Created by Mak Ho-Cheung on 2022/3/23.
//

import Foundation
import V2EXClient

class TopicsAction {
    private let topicsState: TopicsState

    init(topicsState: TopicsState) {
        self.topicsState = topicsState
    }

    func updateTopics(topics: [Topic]) {
        topicsState.topics = topics
    }

    func getTopics() async throws -> [Topic] {
        guard topicsState.topics.isEmpty else {
            return topicsState.topics
        }
        return try await refreshGetTopics()
    }

    func refreshGetTopics() async throws -> [Topic] {
        switch topicsState.listType {
        case .latest:
            return try await V2EXClient.shared.getLatestTopics()
        case .hottest:
            return try await V2EXClient.shared.getHottestTopics()
        }
    }
    
    var hasTopics: Bool {
        return !topicsState.topics.isEmpty
    }
}
