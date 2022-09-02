//
//  TopicView.swift
//  V2 Explore (macOS)
//
//  Created by Mak Ho-Cheung on 2022/9/16.
//

import Kingfisher
import SwiftUI
import V2EXClient

struct TopicView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var topic: Topic?
    @State var replies: [Reply]?
    @State var webViewHeight = CGFloat.zero
    @EnvironmentObject var navigationSelectionState: NavigationSelectionState

    var body: some View {
        ScrollView {
            VStack {
                if let topic {
                    HStack {
                        KFImage(URL(string: topic.member.avatar!))
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
                            Text(topic.member.name)
                            Text(topic.createTime!)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Text("#\(topic.node.title)")
                            .padding(3)
                    }
                    Text(topic.title)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)

                    if topic.content != nil {
                        WebView(webViewHeight: $webViewHeight, content: webContent)
                            .frame(height: webViewHeight)
                        Divider()
                    }
                    ForEach(replies!.indices) { index in
                        let reply = replies![index]
                        VStack {
                            ReplyView(reply: reply, isOP: topic.member.name == reply.member.name, floor: index + 1)
                            Divider()
                        }
                    }
                }
            }
            .padding(.top)
            .padding(.horizontal)
        }
        .onChange(of: navigationSelectionState.topicSelection) { topicId in
            self.topic = nil
            self.replies = nil
            self.webViewHeight = CGFloat.zero
            if let topicId {
                Task {
                    do {
                        let (topic, replies) = try await V2EXClient.shared.getTopicReplies(id: topicId)
                        self.topic = topic
                        self.replies = replies
                    } catch {
                        print(error)
                    }
                }
            }
        }
        .task {
            if let id = navigationSelectionState.topicSelection {
                do {
                    let (topic, replies) = try await V2EXClient.shared.getTopicReplies(id: id)
                    self.topic = topic
                    self.replies = replies
                } catch {
                    print(error)
                }
            }
        }
    }

    var webContent: String {
        if colorScheme == .dark {
            return htmlDarkTemplate.replacingOccurrences(of: "$body", with: topic!.content!)
        } else {
            return htmlTemplate.replacingOccurrences(of: "$body", with: topic!.content!)
        }
    }
}
