//
//  NodeView.swift
//
//  Created by Mak Ho-Cheung on 2022/1/23.
//

import Kingfisher
import SwiftUI
import V2EXClient

struct NodeView: View {
    @State var topics: [Topic] = []
    @State var currentNode: Node?
    var appAction = AppContext.shared.appAction
    #if os(macOS)
        @EnvironmentObject var navigationSelectionState: NavigationSelectionState
    #endif

    #if os(macOS)
        var node: Node? {
            switch navigationSelectionState.sidebarSelection {
            case let .node(node):
                return node
            default:
                return nil
            }
        }
    #else
        var node: Node?
    #endif

    var body: some View {
        if let node {
            ZStack {
                listView
                bgView
            }
            .navigationTitle(node.title)
        } else {
            EmptyView()
        }
    }

    var bgView: some View {
        topics.isEmpty ? AnyView(ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)) : AnyView(EmptyView())
    }

    #if os(macOS)
        var listView: some View {
            List(selection: $navigationSelectionState.topicSelection) {
                if let currentNode = currentNode {
                    VStack(spacing: 10) {
                        KFImage(URL(string: currentNode.avatar!))
                            .placeholder({ _ in
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                            })
                            .fade(duration: 0.25)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                        Text(currentNode.title)
                            .fixedSize(horizontal: false, vertical: true)
                        HStack {
                            Spacer()
                            Text("\(currentNode.count!) 个主题")
                                .padding(5)
                        }
                    }
                    ForEach(topics) {
                        SimpleTopicNavigationLinkView(topic: $0)
                            .tag($0.id)
                    }
                }
            }
            .listStyle(.sidebar)
            .task(id: navigationSelectionState.sidebarSelection) {
                self.currentNode = nil
                self.topics = []
                do {
                    #if DEBUG
                        topics = debugTopics
                        currentNode = Node.mock
                    #else
                        let (node, topics) = try await V2EXClient.shared.getNodeTopics(node: node!)
                        self.topics = topics
                        currentNode = node
                    #endif
                } catch {
                    if error.localizedDescription != "cancelled" {
                        print("[v2-explore]: \(error.localizedDescription)")
                        appAction.updateErrorMsg(errorMsg: "网络请求异常")
                        appAction.toggleIsShowErrorMsg()
                    }
                }
            }
        }
    #else
        var listView: some View {
            List {
                if let currentNode = currentNode {
                    VStack(spacing: 10) {
                        KFImage(URL(string: currentNode.avatar!))
                            .placeholder({ _ in
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                            })
                            .fade(duration: 0.25)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                        Text(currentNode.title)
                            .fixedSize(horizontal: false, vertical: true)
                        HStack {
                            Spacer()
                            Text("\(currentNode.count!) 个主题")
                                .padding(5)
                                .background(Color("TagColor"))
                                .cornerRadius(5)
                        }
                    }
                    .listRowSeparator(.hidden)
                    ForEach(topics) {
                        SimpleTopicNavigationLinkView(topic: $0)
                    }
                }
            }
            .listStyle(.plain)
            .task {
                do {
                    #if DEBUG
                        topics = debugTopics
                        currentNode = Node.mock
                    #else
                        let (node, topics) = try await V2EXClient.shared.getNodeTopics(node: node!)
                        self.topics = topics
                        currentNode = node
                    #endif
                } catch {
                    if error.localizedDescription != "cancelled" {
                        print("[v2-explore]: \(error.localizedDescription)")
                        appAction.updateErrorMsg(errorMsg: "网络请求异常")
                        appAction.toggleIsShowErrorMsg()
                    }
                }
            }
        }
    #endif
}

#if DEBUG
    struct NodeView_Previews: PreviewProvider {
        static var previews: some View {
            NavigationView {
                Text("test")
            }
        }
    }
#endif
