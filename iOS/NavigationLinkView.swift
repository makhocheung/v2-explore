//
//  NavigationLinkView.swift
//  V2EX You (iOS)
//
//  Created by Mak Ho-Cheung on 2022/1/29.
//

import SwiftUI

struct NavigationLinkView: View {
    @State var isActive = false
    let topic: Topic

    var body: some View {
        ZStack {
            NavigationLink(isActive: $isActive) {
                TopicView(topic: topic)
            } label: {
                EmptyView()
            }
            BriefTopicView(briefTopic: topic)
        }
        .background(Color("ContentBackgroundColor"))
        .opacity(isActive ? 0.5 : 1)
        .onTapGesture {
            isActive.toggle()
        }
    }
}
