//
//  NodeView.swift
//
//  Created by Mak Ho-Cheung on 2022/1/23.
//

import Kingfisher
import SwiftUI
import V2EXClient
import Shimmer

struct NodeView: View {
    @State var topics: [Topic] = []
    @State var fullNode: Node?
    @EnvironmentObject var appState: AppState

    #if os(macOS)
        @State var node: Node?
        @State var isShowNodesSelectionView = false
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
            Label("info.noNodeSelection", systemImage: "water.waves.slash")
            #if os(macOS)
                .sheet(isPresented: $isShowNodesSelectionView) {
                    NodesSelectionView(node: $node)
                }
                .toolbar {
                    ToolbarItem {
                        Button {
                            isShowNodesSelectionView.toggle()
                        } label: {
                            Text("info.selectNode")
                        }
                    }
                }
            #endif
        }
    }

    var bgView: some View {
        topics.isEmpty ? AnyView(ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)) : AnyView(EmptyView())
    }

    #if os(macOS)
        var listView: some View {
            List(selection: $appState.topicSelection) {
                if let fullNode {
                    VStack(spacing: 10) {
                        KFImage(URL(string: fullNode.avatar!))
                            .placeholder({ _ in
                                Rectangle()
                                    .fill(.gray.opacity(0.7))
                                    .frame(width: 100, height: 100)
                                    .shimmering()
                            })
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                        Text(fullNode.title)
                            .fixedSize(horizontal: false, vertical: true)
                        HStack {
                            Spacer()
                            Text("info.themeCount \(fullNode.count ?? 0)")
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
            .sheet(isPresented: $isShowNodesSelectionView) {
                NodesSelectionView(node: $node)
            }
            .task(id: node) {
                fullNode = nil
                topics.removeAll()
                do {
                    let (node, topics) = try await V2EXClient.shared.getNodeTopics(node: node!)
                    self.topics = topics
                    fullNode = node
                } catch {
                    if error.localizedDescription != "cancelled" {
                        appState.show(errorInfo: "info.network.error")
                    }
                }
            }
            .toolbar {
                ToolbarItem {
                    Button {
                        isShowNodesSelectionView = true
                    } label: {
                        Text("info.selectNode")
                    }
                }
                ToolbarItem {
                    Button {
                        fullNode = nil
                        appState.topicSelection = nil
                        topics.removeAll()
                        Task {
                            do {
                                let (node, topics) = try await V2EXClient.shared.getNodeTopics(node: node!)
                                self.topics = topics
                                fullNode = node
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
                if let fullNode {
                    VStack(spacing: 10) {
                        KFImage(URL(string: fullNode.avatar!))
                            .placeholder({ _ in
                                Rectangle()
                                    .fill(.gray.opacity(0.7))
                                    .frame(width: 100, height: 100)
                                    .shimmering()
                            })
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                        Text(fullNode.title)
                            .fixedSize(horizontal: false, vertical: true)
                        HStack {
                            Spacer()
                            Text("info.themeCount \(fullNode.count!)")
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
                    fullNode = node
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
