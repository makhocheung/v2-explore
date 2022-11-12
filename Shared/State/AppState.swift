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
    @Published var user: User?

    init() {
        let ud = UserDefaults.standard
        let name = ud.string(forKey: "username")
        let avatar = ud.string(forKey: "avatar")
        let url = ud.string(forKey: "url")
        if let name, let avatar, let url {
            user = User(name: name, url: url, avatar: avatar)
        }
    }

    let navigationNodes = try! V2EXClient.shared.getNavigatinNodes()
    var preSignIn: PreSignIn!

    func show(errorInfo: String) {
        isShowErrorInfo = true
        self.errorInfo = errorInfo
    }

    func show(normalInfo: String) {
        isShowNormalInfo = true
        self.normalInfo = normalInfo
    }

    func upateUser(user: User) {
        self.user = user
        let ud = UserDefaults.standard
        ud.setValue(user.name, forKey: "username")
        ud.setValue(user.avatar, forKey: "avatar")
        ud.setValue(user.url, forKey: "url")
    }

    #if os(macOS)
        @Published var sidebarSelection: SidebarTag?
        @Published var topicSelection: String?
        @Published var isShowLoginView = false

        func clearTopicSelection() {
            topicSelection = nil
        }

        func clearSidebarSelection() {
            sidebarSelection = nil
        }
    #endif
}
