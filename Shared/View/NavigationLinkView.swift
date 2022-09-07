//
//  NavigationLinkView.swift
//  V2EX You (iOS)
//
//  Created by Mak Ho-Cheung on 2022/1/29.
//

import SwiftUI
import V2EXClient

struct NavigationLinkView: View {
    let topic: Topic

    var body: some View {
        VStack {
            NavigationLink {
                TopicView(topicId: topic.id)
            } label: {
                SimpleTopicView(briefTopic: topic)
                    .padding(.horizontal)
            }
            Divider()
                .padding(.horizontal)
        }
    }
}

#if DEBUG
    struct NavigationLinkView_Previews: PreviewProvider {
        static var previews: some View {
            NavigationLinkView(topic: debugTopic)
        }
    }
#endif
