//
// Created by Mak Ho-Cheung on 2022/3/23.
//

import Foundation

class AppContext {

    static let shared = AppContext()

    let appState: AppState

    let appAction: AppAction

    init() {
        appState = AppState()
        appAction = AppAction(appState: appState)
    }
}
