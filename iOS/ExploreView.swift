//
//  HomeView.swift
//  V2EX You
//
//  Created by Mak Ho-Cheung on 2021/11/23.
//

import SwiftUI

struct ExploreView: View {
    @State var listType = ExploreTopicListType.latest
    @StateObject var latestTopicStore = AppStore.latestTopicStore
    @StateObject var hottestTopicStore = AppStore.hottestTopicStore
    var body: some View {
        List {
            Section {
                switch listType {
                case .latest:
                    ForEach(latestTopicStore.topics) {
                        NavigationLinkView(topic: $0)
                    }
                case .hottest:
                    ForEach(hottestTopicStore.topics) {
                        NavigationLinkView(topic: $0)
                    }
                }
            }
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
        }
        .background(bgView)
        .listStyle(.plain)
        .task {
            do {
                switch listType {
                case .latest:
                    latestTopicStore.loadTopics(topics: try await getTopics(topicStore: latestTopicStore))
                case .hottest:
                    hottestTopicStore.loadTopics(topics: try await getTopics(topicStore: hottestTopicStore))
                }
                print("Get \(listType) topics")
            } catch {
                print("error: \(error)")
            }
        }
        .refreshable {
            do {
                switch listType {
                case .latest:
                    latestTopicStore.loadTopics(topics: try await refreshGetTopics(topicStore: latestTopicStore))
                case .hottest:
                    hottestTopicStore.loadTopics(topics: try await refreshGetTopics(topicStore: hottestTopicStore))
                }
                print("Get \(listType) topics")
            } catch {
                print(error)
            }
        }
        .toolbar {
            ToolbarItem {
                Picker("类型", selection: $listType) {
                    Text("最新")
                        .tag(ExploreTopicListType.latest)
                    Text("热门")
                        .tag(ExploreTopicListType.hottest)
                }
                .pickerStyle(.segmented)
                .onChange(of: listType) { _ in
                    Task {
                        do {
                            switch listType {
                            case .latest:
                                latestTopicStore.loadTopics(topics: try await getTopics(topicStore: latestTopicStore))
                            case .hottest:
                                hottestTopicStore.loadTopics(topics: try await getTopics(topicStore: hottestTopicStore))
                            }
                            print("Get \(listType) topics")
                        } catch {
                            print(error)
                        }
                    }
                }
            }
        }
    }

    var bgView: some View {
        ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func getTopics(topicStore: TopicsStore) async throws -> [Topic] {
        guard topicStore.topics.isEmpty else {
            return topicStore.topics
        }
        return try await refreshGetTopics(topicStore: topicStore)
    }

    private func refreshGetTopics(topicStore: TopicsStore) async throws -> [Topic] {
        switch topicStore.listType {
        case .latest:
            return try await APIService.shared.getLatestTopics()
        case .hottest:
            return try await APIService.shared.getHottestTopics()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}
