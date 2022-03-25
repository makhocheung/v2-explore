//
// Created by Mak Ho-Cheung on 2022/3/1.
//

import Foundation
import V2EXClient

class TopicsState: ObservableObject {
    @Published var topics: [Topic] = []

    let listType: ExploreTopicListType

    init(_ listType: ExploreTopicListType) {
        self.listType = listType
    }
}
