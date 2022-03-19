//
//  AppAction.swift
//  V2 Explore
//
//  Created by Mak Ho-Cheung on 2022/3/23.
//
//

import SwiftUI

class AppAction {
    private let appState: AppState

    init(appState: AppState) {
        self.appState = appState
    }

    func updateErrorMsg(errorMsg: String) {
        appState.errorMsg = errorMsg
    }

    func toggleIsShowErrorMsg() {
        appState.isShowErrorMsg.toggle()
    }
}

