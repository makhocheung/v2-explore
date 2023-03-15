//
//  SimpleTopicNavigationLinkView.swift
//  V2 Explore
//
//  Created by Mak Ho-Cheung on 2022/9/9.
//

import SwiftUI

import SwiftUI
import V2EXClient

struct SimpleTopicNavigationLinkView: View {
    let topic: Topic

    var body: some View {
        #if os(macOS)
            SimpleTopicView(topic: topic)
        #else
            SimpleTopicView(topic: topic)
                .overlay {
                    NavigationLink(value: topic.id) {
                        EmptyView()
                    }
                    .opacity(0)
                }

        #endif
    }
}
