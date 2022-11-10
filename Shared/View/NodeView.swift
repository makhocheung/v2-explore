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
    @EnvironmentObject var appState: AppState

    #if os(macOS)
        var node: Node? {
            switch appState.sidebarSelection {
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
            List(selection: $appState.topicSelection) {
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
                            Text("info.themeCount \(currentNode.count!)")
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
            .task(id: appState.sidebarSelection) {
                currentNode = nil
                topics.removeAll()
                do {
                    let (node, topics) = try await V2EXClient.shared.getNodeTopics(node: node!)
                    self.topics = topics
                    currentNode = node
                } catch {
                    if error.localizedDescription != "cancelled" {
                        appState.show(errorInfo: "info.network.error")
                    }
                }
            }
            .toolbar {
                ToolbarItem {
                    Button {
                        currentNode = nil
                        topics.removeAll()
                        Task {
                            do {
                                let (node, topics) = try await V2EXClient.shared.getNodeTopics(node: node!)
                                self.topics = topics
                                currentNode = node
                            } catch {
                                if error.localizedDescription != "cancelled" {
                                    appState.show(errorInfo: "info.network.error")
                                }
                            }
                        }
                    } label: {
                        Image(systemName: "arrow.clockwise")
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
                            Text("info.themeCount \(currentNode.count!)")
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
            .navigationDestination(for: String.self) {
                TopicView(topicId: $0)
            }
            .task {
                do {
                    let (node, topics) = try await V2EXClient.shared.getNodeTopics(node: node!)
                    self.topics = topics
                    currentNode = node
                } catch {
                    if error.localizedDescription != "cancelled" {
                        appState.show(errorInfo: "info.network.error")
                    }
                }
            }
        }
    #endif
}

#if DEBUG
    struct NodeView_Previews: PreviewProvider {
        static var previews: some View {
            NodeView()
        }
    }
#endif
