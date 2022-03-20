//
//  AppStore.swift
//  V2EX You
//
//  Created by Mak Ho-Cheung on 2022/3/4.
//

import SwiftUI

import Foundation

class AppStore {
    static let HOTTEST_NODES = ["programmer", "create", "share", "apple", "jobs", "all4all", "guangzhou", "qna"]

    static let latestTopicStore = TopicsStore(.latest)
    static let hottestTopicStore = TopicsStore(.hottest)
    static let user = UserStore()
    static let errorStore = ErrorStore()
}
