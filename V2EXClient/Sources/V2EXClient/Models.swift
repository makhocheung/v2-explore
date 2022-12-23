//
//  Models.swift
//  V2EX You
//
//  Created by Mak Ho-Cheung on 2021/11/23.
//

import Foundation
import SwiftUI

public struct Topic: Codable, Identifiable {
    public let id: String
    public let node: Node
    public let member: Member
    public let title: String
    public let content: String?
    public let url: String?
    public let replyCount: Int?
    public let createTime: String?
    public let lastReplyBy: Member?
    public let lastTouched: String?
    public let pageCount: Int?
    public var contentSections: [ContentSection] = []

    enum CodingKeys: String, CodingKey {
        case id, node, member, title, content, url, replyCount, createTime, lastReplyBy, lastTouched, pageCount
    }
}

public struct Member: Codable {
    public var name: String
    public var url: String?
    public var avatar: String?
}

public struct Node: Codable, Identifiable, Equatable, Hashable {
    public var id = UUID()
    public var title: String
    public var url: String
    public var name: String
    public var parentNodeName: String?
    public var avatar: String?
    public var desc: String?
    public var count: Int?

    public static let mock = Node(title: "Java", url: "https://www.v2ex.com/go/java", name: "Java", avatar: "https://cdn.v2ex.com/navatar/03af/dbd6/63_xlarge.png?m=1644490200", desc: "Sun 公司发明，被广泛使用的一门编程语言。", count: 5103)
}

public struct Reply: Codable, Identifiable {
    public var id: String
    public var content: String
    public var attributeStringContent: AttributedString
    public var member: Member
    public var creatTime: String
}

public struct ContentSection: Identifiable {
    public enum ContentSectionType {
        case literal, image, code, video
    }

    public let id = UUID()
    public var type: ContentSectionType
    public var content: Any
}

public enum V2EXClientError: Error {
    case unavailable, loginFailed
}

public struct PreSignIn {
    public let usernameKey: String
    public let passwordKey: String
    public let captchaKey: String
    public let once: String
    public let captchaUrl = URL(string: "https://v2ex.com/_captcha")!
}

public struct SignIn {
    public let usernameKey: String
    public let passwordKey: String
    public let captchaKey: String
    public let username: String
    public let password: String
    public let captcha: String
    public let once: String

    public init(usernameKey: String, passwordKey: String, captchaKey: String, username: String, password: String, captcha: String, once: String) {
        self.usernameKey = usernameKey
        self.passwordKey = passwordKey
        self.captchaKey = captchaKey
        self.username = username
        self.password = password
        self.captcha = captcha
        self.once = once
    }
}

public struct Token {
    public let a2: String
    public let a2ExpireDate: Date

    public init(a2: String, a2ExpireDate: Date) {
        self.a2 = a2
        self.a2ExpireDate = a2ExpireDate
    }
}

public struct User: Identifiable {
    public let id = UUID()
    public let name: String
    public let avatar: String
    public var favoriteNodeCount: Int?
    public var favoriteTopicCount: Int?
    public var followerCount: Int?
    public var notificationCount: Int?
    public var silverCount: Int?
    public var bronzeCount: Int?
    public var memberDesc: String?
    public var activityRank: Int?

    public init(name: String, avatar: String) {
        self.name = name
        self.avatar = avatar
    }

    public init(name: String, avatar: String, favoriteNodeCount: Int?, favoriteTopicCount: Int?, followerCount: Int?, notificationCount: Int?, silverCount: Int?, bronzeCount: Int?) {
        self.name = name
        self.avatar = avatar
        self.favoriteNodeCount = favoriteNodeCount
        self.favoriteTopicCount = favoriteTopicCount
        self.followerCount = followerCount
        self.notificationCount = notificationCount
        self.silverCount = silverCount
        self.bronzeCount = bronzeCount
    }

    public init(name: String, avatar: String, memberDesc: String?, activityRank: Int?) {
        self.name = name
        self.avatar = avatar
        self.memberDesc = memberDesc
        self.activityRank = activityRank
    }

    public init(name: String, avatar: String, favoriteNodeCount: Int?, favoriteTopicCount: Int?, followerCount: Int?, notificationCount: Int?, silverCount: Int?, bronzeCount: Int?, memberDesc: String?, activityRank: Int?) {
        self.name = name
        self.avatar = avatar
        self.favoriteNodeCount = favoriteNodeCount
        self.favoriteTopicCount = favoriteTopicCount
        self.followerCount = followerCount
        self.notificationCount = notificationCount
        self.silverCount = silverCount
        self.bronzeCount = bronzeCount
        self.memberDesc = memberDesc
        self.activityRank = activityRank
    }

    public static func merge(l: User, r: User) -> User {
        User(name: l.name, avatar: l.avatar, favoriteNodeCount: l.favoriteNodeCount ?? r.favoriteNodeCount, favoriteTopicCount: l.favoriteTopicCount ?? r.favoriteTopicCount, followerCount: l.followerCount ?? r.followerCount, notificationCount: l.notificationCount ?? r.notificationCount, silverCount: l.silverCount ?? r.silverCount, bronzeCount: l.bronzeCount ?? r.bronzeCount, memberDesc: l.memberDesc ?? r.memberDesc, activityRank: l.activityRank ?? r.activityRank)
    }
}
