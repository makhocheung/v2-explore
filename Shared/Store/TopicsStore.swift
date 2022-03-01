//
// Created by Mak Ho-Cheung on 2022/3/1.
//

import Foundation

class TopicsStore: ObservableObject {
    @Published var topics: [Topic] = []

    let listType: ExploreTopicListType

    init(_ listType: ExploreTopicListType) {
        self.listType = listType
    }

    public func loadTopics(topics: [Topic]) {
        self.topics = topics
    }
}
