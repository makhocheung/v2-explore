//
//  ShowStore.swift
//  V2 Explore
//
//  Created by Mak Ho-Cheung on 2022/3/20.
//

import Foundation
import V2EXClient

class AppState: ObservableObject {
    @Published var isShowErrorInfo = false
    @Published var errorInfo = ""
    @Published var isShowNormalInfo = false
    @Published var normalInfo = ""

    let navigationNodes = try! V2EXClient.shared.getNavigatinNodes()

    func show(errorInfo: String) {
        isShowErrorInfo = true
        self.errorInfo = errorInfo
    }

    func show(normalInfo: String) {
        isShowNormalInfo = true
        self.normalInfo = normalInfo
    }

    #if os(macOS)
        @Published var sidebarSelection: SidebarTag?
        @Published var topicSelection: String?

        func clearTopicSelection() {
            topicSelection = nil
        }

        func clearSidebarSelection() {
            sidebarSelection = nil
        }
    #endif
}
