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
        let a2 = ud.string(forKey: "a2")
        let a2ExpireDateAny = ud.object(forKey: "a2ExpireDate")

        if let name, let avatar, let url, let a2, let a2ExpireDate = a2ExpireDateAny as? Date {
            if a2ExpireDate > Date.now {
                user = User(name: name, url: url, avatar: avatar, a2: a2, a2ExpireDate: a2ExpireDate as! Date)
            } else {
                ud.removeObject(forKey: "username")
                ud.removeObject(forKey: "avatar")
                ud.removeObject(forKey: "url")
                ud.removeObject(forKey: "a2")
                ud.removeObject(forKey: "a2ExpireDate")
            }
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
        ud.setValue(user.a2, forKey: "a2")
        ud.setValue(user.a2ExpireDate, forKey: "a2ExpireDate")
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
