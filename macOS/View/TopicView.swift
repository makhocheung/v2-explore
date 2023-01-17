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

    var body: some View {
        ZStack {
            if let topic {
                GeometryReader { proxy in
                    ScrollView {
                        VStack {
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
                                        .cornerRadius(4)
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
                                            .placeholder { _ in
                                                Rectangle()
                                                    .fill(.gray.opacity(0.7))
                                                    .shimmering()
                                            }
                                            .resizable()
                                            .scaledToFit()
                                    case .code:
                                        Text($0.content as! AttributedString)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.horizontal)
                                            .padding(.top)
                                            .background(.thinMaterial)
                                            .cornerRadius(5)
                                            .padding(.bottom)
                                    default:
                                        EmptyView()
                                    }
                                }
                                Divider()
                            }
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
                        .onPreferenceChange(IsScrollToBottomKey.self) { newValue in
                            if !self.isLoadingReply && newValue {
                                if let id = self.topic?.id, let nextPage = self.topic?.nextPage {
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
            if let topicId = appState.topicSelection {
                ToolbarItemGroup {
                    Group {
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
            }
        }
        .task {
            if let id = appState.topicSelection {
                do {
                    let (topic, replies) = try await V2EXClient.shared.getTopicReplies(id: id)
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
