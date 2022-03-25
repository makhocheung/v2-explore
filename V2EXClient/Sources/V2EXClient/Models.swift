//
//  Models.swift
//  V2EX You
//
//  Created by Mak Ho-Cheung on 2021/11/23.
//

import Foundation
import SwiftUI

public struct Topic: Identifiable {
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
}

public struct Member {
    public var url: String?
    public var name: String
    public var avatar: String?
}

public struct Node {
    public var title: String
    public var url: String
    public var name: String
    public var parentNodeName: String?
}

public struct Reply: Identifiable {
    public var member: Member
    public var creatTime: String
    // public var topicId: String
    public var content: String
    public var id: String
}
