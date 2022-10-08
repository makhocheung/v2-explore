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
        VStack(spacing: 0) {
            SimpleTopicView(topic: topic)
            Rectangle()
                .foregroundColor(.accentColor.opacity(0.2))
                .frame(maxWidth: .infinity)
                .frame(height: 1)
                .offset(y: 4.5)
        }
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
