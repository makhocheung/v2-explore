//
//  TopicView.swift
//  V2EX You
//
//  Created by Mak Ho-Cheung on 2021/12/8.
//

import Kingfisher
import SwiftUI
import V2EXClient
import WebKit

struct TopicView: View {
    @Environment(\.colorScheme) var colorScheme
    let topicId: String
    @State var topic: Topic?
    @State var replies: [Reply]?
    @State var replyContent = ""
    @State var webViewHeight = CGFloat.zero

    var body: some View {
        ScrollView {
            VStack {
                if let topic = topic {
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
                        Text(topic.node.title)
                            .padding(3)
                            .background(Color("TagColor"))
                            .cornerRadius(4)
                    }
                    Text(topic.title)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)

                    if topic.content != nil {
                        WebView(webViewHeight: $webViewHeight, content: webContent)
                            .frame(height: webViewHeight)
                        Divider()
                    }
                    if let replies = replies {
                        ForEach(replies.indices) { floor in
                            let reply = replies[floor]
                            VStack {
                                ReplyView(reply: reply, isOP: topic.member.name == reply.member.name, floor: floor + 1)
                                Divider()
                            }
                            
                        }
                    } else {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding(.horizontal)
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            do {
                let (topic, replies) = try await V2EXClient.shared.getTopicReplies(id: topicId)
                self.topic = topic
                self.replies = replies
            } catch {
                print(error)
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

#if DEBUG
//    struct TopicView_Previews: PreviewProvider {
//        static var previews: some View {
//            NavigationView {
//                TopicView(topic: debugTopic)
//            }
//        }
//    }
#endif
