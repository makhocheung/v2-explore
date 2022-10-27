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
    @State var isShoading = false
    @EnvironmentObject var appState: AppState
    @Environment(\.openURL) var openURL

    var body: some View {
        ZStack {
            if let topic {
                ScrollView {
                    VStack {
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
                            .textSelection(.enabled)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom)

                        if !topic.contentSections.isEmpty {
                            ForEach(topic.contentSections) {
                                switch $0.type {
                                case .literal:
                                    Text($0.content as! AttributedString)
                                        .textSelection(.enabled)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                case .image:
                                    KFImage(URL(string: $0.content as! String)!)
                                        .resizable()
                                        .scaledToFit()
                                default:
                                    EmptyView()
                                }
                            }
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
                    .padding(.top)
                    .padding(.horizontal)
                }
            } else if isShoading {
                ProgressView()
            } else {
                Text("No content")
            }
        }
        .toolbar {
            if let topic {
                ToolbarItemGroup {
                    Button {
                        let pasteBoard = NSPasteboard.general
                        pasteBoard.clearContents()
                        pasteBoard.setString("https://v2ex.com/t/\(topic.id)", forType: .string)
                        appState.show(normalInfo: "链接已复制到粘贴板")
                    } label: {
                        Image(systemName: "doc.on.doc")
                    }
                    .help("复制帖子链接")
                    
                    Button {
                        openURL(URL(string: "https://v2ex.com/t/\(topic.id)")!)
                    }label: {
                        Image(systemName: "safari")
                    }
                    .help("用浏览器打开")
                }
            }
        }
        .onChange(of: appState.topicSelection) { topicId in
            self.topic = nil
            self.replies = nil
            self.webViewHeight = CGFloat.zero
            if let topicId {
                self.isShoading = true
                Task {
                    do {
                        let (topic, replies) = try await V2EXClient.shared.getTopicReplies(id: topicId)
                        self.topic = topic
                        self.replies = replies
                        self.isShoading = false
                    } catch V2EXClientError.unavailable {
                        appState.show(normalInfo: "你无权限访问该帖子")
                    } catch {
                        appState.show(errorInfo: "\(error)")
                    }
                }
            }
        }
        .task {
            if let id = appState.topicSelection {
                do {
                    let (topic, replies) = try await V2EXClient.shared.getTopicReplies(id: id)
                    self.topic = topic
                    self.replies = replies
                    self.isShoading = false
                } catch V2EXClientError.unavailable {
                    appState.isShowErrorInfo = true
                    appState.errorInfo = "你无权限访问该帖子"
                } catch {
                    appState.isShowErrorInfo = true
                    appState.errorInfo = "\(error)"
                }
            }
        }
    }
}
