//
//  ShowStore.swift
//  V2 Explore
//
//  Created by Mak Ho-Cheung on 2022/3/20.
//

import Combine
import Foundation
import SwiftUI
import V2EXClient

class AppState: ObservableObject {
    @Published var isShowErrorInfo = false
    @Published var errorInfo = ""
    @Published var isShowNormalInfo = false
    @Published var normalInfo = ""
    @Published var user: User?
    @Published var token: Token?
    @Published var searchResult: SearchResult?
    @Published var searching = false
    @Published var replyObjectInfo: ReplyObjectInfo?
    @Published var searchContent = ""
    // @Published var userProfileSelection: UserProfileSelection?
    // @Published var isShowPostReply = false
    #if os(macOS)
        @Published var sidebarSelection: SidebarTag?
        @Published var topicSelection: String?
        @Published var isShowLoginView = false
    #endif
    let navigationNodes = try! V2EXClient.shared.getNavigatinNodes()
    var cancellableSet: Set<AnyCancellable> = []
    var preSignIn: PreSignIn!
    #if os(macOS)
        var needRefreshTopic = false
    #endif

    init() {
        let ud = UserDefaults.standard
        let name = ud.string(forKey: "username")
        let avatar = ud.string(forKey: "avatar")
        let a2 = ud.string(forKey: "a2")
        let a2ExpireDateAny = ud.object(forKey: "a2ExpireDate")

        if let name, let avatar, let a2, let a2ExpireDate = a2ExpireDateAny as? Date {
            if a2ExpireDate > Date.now {
                user = User(name: name, avatar: avatar)
                token = Token(a2: a2, a2ExpireDate: a2ExpireDate)
            } else {
                ud.removeObject(forKey: "username")
                ud.removeObject(forKey: "avatar")
                ud.removeObject(forKey: "a2")
                ud.removeObject(forKey: "a2ExpireDate")
            }
        }
        #if os(macOS)
            let searchCancellable = $searchContent.sink { it in
                if !it.isEmpty {
                    self.sidebarSelection = SidebarTag.search
                } else {
                    self.searchResult = nil
                    self.searching = false
                    if self.sidebarSelection == .search {
                        self.topicSelection = nil
                    }
                }
            }
            cancellableSet.insert(searchCancellable)
        #endif
    }

    @MainActor
    func show(errorInfo: String) {
        isShowErrorInfo = true
        self.errorInfo = errorInfo
    }

    @MainActor
    func show(normalInfo: String) {
        isShowNormalInfo = true
        self.normalInfo = normalInfo
    }

    func upateUserAndToken(user: User, token: Token) {
        self.user = user
        self.token = token
        let ud = UserDefaults.standard
        ud.setValue(user.name, forKey: "username")
        ud.setValue(user.avatar, forKey: "avatar")
        ud.setValue(token.a2, forKey: "a2")
        ud.setValue(token.a2ExpireDate, forKey: "a2ExpireDate")
    }

    func signOut() {
        user = nil
        token = nil
        let ud = UserDefaults.standard
        ud.removeObject(forKey: "username")
        ud.removeObject(forKey: "avatar")
        ud.removeObject(forKey: "a2")
        ud.removeObject(forKey: "a2ExpireDate")
        let s = HTTPCookieStorage.shared
        s.cookies?.forEach {
            s.deleteCookie($0)
        }
    }

    func search() {
        searching = true
        Task {
            do {
                let searchResult = try await V2EXClient.shared.search(keyword: searchContent)
                await update(searchResult: searchResult)
            } catch {
                print(error)
            }
        }
    }

    @MainActor
    func update(searchResult: SearchResult) {
        self.searchResult = searchResult
        searching = false
    }

    #if os(macOS)
        func clearTopicSelection() {
            topicSelection = nil
        }

        func clearSidebarSelection() {
            sidebarSelection = nil
        }
    #endif
}

struct UserProfileSelection: Identifiable {
    let id = UUID()
    let isLoginUser: Bool
    let username: String

    public init(isLoginUser: Bool = false, username: String) {
        self.isLoginUser = isLoginUser
        self.username = username
    }
}

struct ReplyObjectInfo: Identifiable {
    let id: String
    let username: String
    let isReplyTopic: Bool
    let outline: String
}
