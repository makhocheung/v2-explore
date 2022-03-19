//
// Created by Mak Ho-Cheung on 2022/3/23.
//

import Foundation

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
            return try await APIService.shared.getLatestTopics()
        case .hottest:
            return try await APIService.shared.getHottestTopics()
        }
    }
}
