//
//  TopicView.swift
//  V2EX You
//
//  Created by Mak Ho-Cheung on 2021/12/8.
//

import Kingfisher
import SwiftUI
import WebKit
import V2EXClient

struct TopicView: View {
    @Environment(\.colorScheme) var colorScheme
    var topic: Topic
    @State var replyContent = ""
    @State var webViewHeight = CGFloat.zero

    var body: some View {
        List {
            HStack {
                KFImage(URL(string: topic.member.avatarLarge))
                    .placeholder({ _ in
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                    })
                    .fade(duration: 0.25)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .cornerRadius(4)
                VStack(alignment: .leading, spacing: 5) {
                    Text(topic.member.username)
                    Text(timestamp2Date(timestamp: topic.lastModified))
                        .foregroundColor(.secondary)
                }
                Spacer()
                Text(topic.node.title)
                    .padding(3)
                    .background(Color("TagColor"))
                    .cornerRadius(4)
            }
            .listRowSeparator(.hidden)
            Text(topic.title)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .listRowSeparator(.hidden)

            if !topic.contentRendered.isEmpty {
                VStack {
                    WebView(webViewHeight: $webViewHeight, content: webContent)
                        .frame(height: webViewHeight)
                    Divider()
                }
                .listRowSeparator(.hidden)
            }
            RepliesView(topic: topic)
        }
        .listStyle(.plain)
        .navigationBarTitleDisplayMode(.inline)
    }

    var webContent: String {
        if colorScheme == .dark {
            return htmlDarkTemplate.replacingOccurrences(of: "$body", with: topic.contentRendered)
        } else {
            return htmlTemplate.replacingOccurrences(of: "$body", with: topic.contentRendered)
        }
    }
}

#if DEBUG
struct TopicView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TopicView(topic: debugTopic)
        }
    }
}
#endif
