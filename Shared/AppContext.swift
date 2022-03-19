//
// Created by Mak Ho-Cheung on 2022/3/23.
//

import Foundation

class AppContext {

    static let shared = AppContext()

    let appState: AppState
    let latestTopicsState: TopicsState
    let hottestTopicsState: TopicsState

    let appAction: AppAction
    let latestTopicsAction: TopicsAction
    let hottestTopicsAction: TopicsAction

    init() {
        appState = AppState()
        latestTopicsState = TopicsState(.latest)
        hottestTopicsState = TopicsState(.hottest)

        appAction = AppAction(appState: appState)
        latestTopicsAction = TopicsAction(topicsState: latestTopicsState)
        hottestTopicsAction = TopicsAction(topicsState: hottestTopicsState)
    }
}
