//
//  TopicView.swift
//  V2 Explore (macOS)
//
//  Created by Mak Ho-Cheung on 2022/9/16.
//

import Kingfisher
import Shimmer
import SwiftUI
import V2EXClient

struct TopicView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var topic: Topic?
    @State var replies: [Reply]?
    @State var isLoadingTopic = false
    @EnvironmentObject var appState: AppState
    @Environment(\.openURL) var openURL
    @State var userProfileSelection: UserProfileSelection?
    @State var isLoadingReply = false
    @Environment(\.openWindow) var openWindow

    @State var hasReplied = false

    var body: some View {
        ZStack {
            if let topic {
                GeometryReader { proxy in
                    ScrollView {
                        LazyVStack {
                            HStack {
                                Button {
                                    userProfileSelection = UserProfileSelection(username: topic.member!.name)
                                } label: {
                                    KFImage(URL(string: topic.member!.avatar!))
                                        .placeholder({ _ in
                                            Rectangle()
                                                .fill(.gray.opacity(0.7))
                                                .frame(width: 50, height: 50)
                                                .cornerRadius(4)
                                                .shimmering()
                                        })
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
                                        .imageBorder(cornerRadius: 4)
                                }
                                .buttonStyle(.plain)
                                .popover(item: $userProfileSelection) {
                                    UserProfileView(username: $0.username, useHomeData: $0.isLoginUser)
                                }
                                VStack(alignment: .leading, spacing: 5) {
                                    Button {
                                        userProfileSelection = UserProfileSelection(username: topic.member!.name)
                                    } label: {
                                        Text(topic.member!.name)
                                    }
                                    .buttonStyle(.plain)
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
                            TopicContentView(html: topic.content, isMarkdown: topic.isMarkdown)
                            Divider()
                            ForEach(replies!) { reply in
                                VStack {
                                    ReplyView(reply: reply, isOP: topic.member!.name == reply.member.name)
                                    Divider()
                                }
                            }
                            if let _ = topic.nextPage {
                                ProgressView()
                                    .padding(4)
                                    .scaleEffect(0.7)
                            }
                        }
                        .padding(.top)
                        .padding(.horizontal)
                        .background {
                            GeometryReader {
                                let gap = abs(-$0.frame(in: .named("scroll")).origin.y + proxy.size.height - $0.frame(in: .local).height)
                                Color.clear.preference(key: IsScrollToBottomKey.self, value: gap < 1)
                            }
                        }
                        .sheet(item: $appState.replyObjectInfo, onDismiss: {
                            if appState.needRefreshTopic {
                                self.topic = nil
                                self.replies = nil
                                self.isLoadingTopic = true
                                Task {
                                    do {
                                        let (topic, replies) = try await V2EXClient.shared.getTopicReplies(id: appState.topicSelection!)
                                        self.topic = topic
                                        self.replies = replies
                                        self.isLoadingTopic = false
                                        appState.needRefreshTopic = false
                                    } catch V2EXClientError.unavailable {
                                        appState.show(normalInfo: "info.noAccess")
                                    } catch {
                                        appState.show(errorInfo: "info.network.error")
                                    }
                                }
                            }
                        }) { info in
                            PostReplyView(replyObjectInfo: info)
                        }
                        .onPreferenceChange(IsScrollToBottomKey.self) { newValue in
                            if !self.isLoadingReply && newValue {
                                if let id = self.topic?.id, let nextPage = self.topic?.nextPage {
                                    self.isLoadingReply = true
                                    Task {
                                        do {
                                            let (replies, newNextPage) = try await V2EXClient.shared.getRepliesByTopic(id: id, page: nextPage)
                                            loadReplies(replies: replies, nextPage: newNextPage)
                                        } catch {
                                            print(error)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .coordinateSpace(name: "scroll")
                }
            } else if isLoadingTopic {
                ProgressView()
            } else {
                Text("No content")
            }
        }
        .toolbar {
            ToolbarItemGroup {
                Button {
                    openWindow(id: "PostTopic")
                } label: {
                    Image(systemName: "square.and.pencil")
                }
            }
            if let topicId = appState.topicSelection {
                ToolbarItemGroup {
                    Group {
                        Button {
                            appState.replyObjectInfo = ReplyObjectInfo(id: topicId, username: topic!.member!.name, isReplyTopic: true, outline: topic!.title)
                        } label: {
                            Image(systemName: "arrowshape.turn.up.left")
                        }
                        Button {
                            let pasteBoard = NSPasteboard.general
                            pasteBoard.clearContents()
                            pasteBoard.setString("https://v2ex.com/t/\(topicId)", forType: .string)
                            appState.show(normalInfo: "info.copy.link")
                        } label: {
                            Image(systemName: "link")
                        }
                        .help("info.help.copyLink")

                        Button {
                            openURL(URL(string: "https://v2ex.com/t/\(topicId)")!)
                        } label: {
                            Image(systemName: "safari")
                        }
                        .help("info.help.openInBrowser")

                        Button {
                            self.topic = nil
                            self.replies = nil
                            self.isLoadingTopic = true
                            Task {
                                do {
                                    let (topic, replies) = try await V2EXClient.shared.getTopicReplies(id: topicId)
                                    self.topic = topic
                                    self.replies = replies
                                    self.isLoadingTopic = false
                                } catch V2EXClientError.unavailable {
                                    appState.show(normalInfo: "info.noAccess")
                                } catch {
                                    appState.show(errorInfo: "info.network.error")
                                }
                            }
                        } label: {
                            Image(systemName: "arrow.clockwise")
                        }
                    }
                    .disabled(isLoadingTopic)
                }
            }
        }
        .onChange(of: appState.topicSelection) { topicId in
            self.topic = nil
            self.replies = nil
            if let topicId {
                self.isLoadingTopic = true
                Task {
                    do {
                        var (topic, replies) = try await V2EXClient.shared.getTopicReplies(id: topicId)
                        // topic.parsedContent = ContentConverter.shared.convert(html: topic.content!)
                        self.topic = topic
                        self.replies = replies
                        self.isLoadingTopic = false
                    } catch V2EXClientError.unavailable {
                        appState.show(normalInfo: "info.noAccess")
                    } catch {
                        appState.show(errorInfo: "info.network.error")
                    }
                }
            }
        }
        .task {
            if let id = appState.topicSelection {
                do {
                    var (topic, replies) = try await V2EXClient.shared.getTopicReplies(id: id)
                    // topic.parsedContent = ContentConverter.shared.convert(html: topic.content!)
                    self.topic = topic
                    self.replies = replies
                    self.isLoadingTopic = false
                } catch V2EXClientError.unavailable {
                    appState.show(normalInfo: "info.noAccess")
                } catch {
                    appState.show(errorInfo: "info.network.error")
                }
            }
        }
    }

    @MainActor
    func loadReplies(replies: [Reply], nextPage: Int?) {
        self.replies?.append(contentsOf: replies)
        topic?.nextPage = nextPage
        isLoadingReply = false
    }

    struct IsScrollToBottomKey: PreferenceKey {
        typealias Value = Bool
        static var defaultValue = true
        static func reduce(value: inout Value, nextValue: () -> Value) {
            value = value && nextValue()
        }
    }
}

struct VImage: View {
    let url: String
    @State var showPlaceholder = true
    @State var maxWidth = CGFloat.zero
    @State var opacity = 0.0
    var body: some View {
        HStack {
            ZStack {
                KFImage(URL(string: url)!)
                    .onSuccess { it in
                        withAnimation(.default) {
                            opacity = 1.0
                        }
                        maxWidth = min(it.image.size.width, 760.0)
                        showPlaceholder = false
                    }
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: maxWidth)
                    .opacity(opacity)
                if showPlaceholder {
                    Rectangle()
                        .fill(.gray.opacity(0.7))
                        .frame(width: 500, height: 400)
                        .shimmering()
                }
            }

            Spacer()
        }
    }
}
