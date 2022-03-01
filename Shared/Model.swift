//
//  Model.swift
//  V2EX You
//
//  Created by Mak Ho-Cheung on 2021/11/23.
//

import Foundation
import SwiftUI

struct Node: Codable, Identifiable {
    var avatarMini: String
    var avatarNormal: String
    var avatarLarge: String
    var name: String
    var title: String
    var url: String
    var topics: Int
    var footer: String?
    var header: String?
    var titleAlternative: String
    var stars: Int
    var aliases: [String]
    var root: Bool
    var id: Int
    var parentNodeName: String?

    enum CodingKeys: String, CodingKey {
        case avatarMini = "avatar_mini"
        case avatarNormal = "avatar_normal"
        case avatarLarge = "avatar_large"
        case name
        case title
        case url
        case topics
        case footer
        case header
        case titleAlternative = "title_alternative"
        case stars
        case aliases
        case root
        case id
        case parentNodeName = "parent_node_name"
    }
}

struct Member: Codable {
    var avatarMini: String
    var avatarNormal: String
    var avatarLarge: String
    var username: String
    var website: String?
    var github: String?
    var psn: String?
    var bio: String?
    var url: String
    var tagline: String?
    var twitter: String?
    var created: Int64
    var location: String?
    var btc: String?
    var id: Int

    enum CodingKeys: String, CodingKey {
        case avatarMini = "avatar_mini"
        case avatarNormal = "avatar_normal"
        case avatarLarge = "avatar_large"
        case username
        case website
        case github
        case psn
        case bio
        case url
        case tagline
        case twitter
        case created
        case location
        case btc
        case id
    }
}

struct Topic: Codable, Identifiable {
    var node: Node
    var member: Member
    var lastReplyBy: String
    var lastTouched: Int64
    var title: String
    var url: String
    var created: Int64
    var deleted: Int
    var content: String
    var contentRendered: String
    var lastModified: Int64
    var replies: Int
    var id: Int

    enum CodingKeys: String, CodingKey {
        case node
        case member
        case lastReplyBy = "last_reply_by"
        case lastTouched = "last_touched"
        case title
        case url
        case created
        case deleted
        case content
        case contentRendered = "content_rendered"
        case lastModified = "last_modified"
        case replies
        case id
    }
}

struct Reply: Codable, Identifiable {
    var member: Member
    var created: Int64
    var topicId: Int
    var content: String
    var contentRendered: String
    var lastModified: Int64
    var memberId: Int
    var id: Int
    enum CodingKeys: String, CodingKey {
        case member
        case created
        case topicId = "topic_id"
        case content
        case contentRendered = "content_rendered"
        case lastModified = "last_modified"
        case memberId = "member_id"
        case id
    }
}
