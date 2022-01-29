//
//  TopicView.swift
//  V2EX You
//
//  Created by Mak Ho-Cheung on 2021/12/8.
//

import Kingfisher
import SwiftUI
import WebKit

struct TopicView: View {
    @Environment(\.colorScheme) var colorScheme
    var topic = testTopic
    @State var replyContent = ""
    @State var showReplySuccess = false
    @State var webViewHeight = CGFloat.zero

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                KFImage(URL(string: topic.member.avatarLarge))
                    .resizable()
                    .frame(width: 50, height: 50)
                    .cornerRadius(4)
                VStack(alignment: .leading, spacing: 5) {
                    Text(topic.member.username)
                        .bold()
                    Text(timestamp2Date(timestamp: topic.lastModified))
                }
                Spacer()
                Text(topic.node.name)
                    .padding(3)
                    .foregroundColor(Color("StressTextColor"))
                    .background(Color("StressBackgroundColor"))
                    .cornerRadius(4)
            }
            .foregroundColor(.accentColor)
            .padding(.horizontal, 10)
            Text(topic.title)
                .bold()
                .padding(10)
                .frame(maxWidth: .infinity, alignment: .leading)
            Divider()
            ScrollView {
                if !topic.contentRendered.isEmpty {
                    WebView(webViewHeight: $webViewHeight, content: webContent)
                        .frame(height: webViewHeight)
                }
                Divider()
                RepliesView(topic: topic)
            }
            .background(Color("ContentBackgroundColor"))
            HStack {
                HStack {
                    TextField("回复评论", text: $replyContent, prompt: nil)
                    Button {
                        showReplySuccess.toggle()
                    } label: {
                        Image(systemName: "paperplane.fill")
                    }
                }
                .padding(10)
                .background(Color("InputColor"))
                .cornerRadius(8)
            }
            .padding(8)
            .alert("回复成功", isPresented: $showReplySuccess) {
                Text("完成")
            }
        }
        .background(Color("RootBackgroundColor"))
    }

    var webContent: String {
        if colorScheme == .dark {
            return htmlDarkTemplate.replacingOccurrences(of: "$body", with: topic.contentRendered)
        } else {
            return htmlTemplate.replacingOccurrences(of: "$body", with: topic.contentRendered)
        }
    }
}

struct TopicView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TopicView()

            TopicView()
                .preferredColorScheme(.dark)
        }
    }
}
