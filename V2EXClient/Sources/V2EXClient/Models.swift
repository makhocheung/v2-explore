//
//  Models.swift
//  V2EX You
//
//  Created by Mak Ho-Cheung on 2021/11/23.
//

import Foundation
import SwiftUI

public struct Topic: Decodable, Identifiable {
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

public struct Member: Decodable {
    public var name: String
    public var url: String?
    public var avatar: String?
}

public struct Node: Decodable, Identifiable {
    public var id = UUID()
    public var title: String
    public var url: String
    public var name: String
    public var parentNodeName: String?
    public var avatar: String?
    public var desc: String?
    public var count: Int?
    
    public static let mock = Node(title: "Java", url:"https://www.v2ex.com/go/java", name: "Java",avatar: "https://cdn.v2ex.com/navatar/03af/dbd6/63_xlarge.png?m=1644490200",desc: "Sun 公司发明，被广泛使用的一门编程语言。",count: 5103)

}

public struct Reply: Decodable {
    public var id: String
    public var content: String
    public var member: Member
    public var creatTime: String
}
