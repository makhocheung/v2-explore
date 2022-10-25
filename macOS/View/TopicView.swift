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
    @EnvironmentObject var navigationSelectionState: NavigationSelectionState

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
                ToolbarItem {
                    Button {
                        let pasteBoard = NSPasteboard.general
                        pasteBoard.clearContents()
                        pasteBoard.setString("https://v2ex.com/t/\(topic.id)", forType: .string)
                        AppContext.shared.appState.isShowTips = true
                        AppContext.shared.appState.tips = "链接已复制到粘贴板"
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                    .help("复制帖子链接")
                }
            }
        }
        .onChange(of: navigationSelectionState.topicSelection) { topicId in
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
                    self.isShoading = false
                } catch {
                    print(error)
                }
            }
        }
    }
}
