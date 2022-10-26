//
//  HomeView.swift
//  V2EX You
//
//  Created by Mak Ho-Cheung on 2021/11/23.
//

import SwiftUI
import V2EXClient

struct ExploreView: View {
    @State var listType = ExploreTopicType.latest
    @State var latestTopics: [Topic] = []
    @State var hottestTopics: [Topic] = []
    @EnvironmentObject var appState: AppState

    var body: some View {
        ZStack {
            listView
            if showLoading {
                bgView
            }
        }
        .navigationTitle("探索")
        .refreshable {
            do {
                switch listType {
                case .latest:
                    latestTopics = try await V2EXClient.shared.getLatestTopics()
                case .hottest:
                    hottestTopics = try await V2EXClient.shared.getHottestTopics()
                }
            } catch {
                if error.localizedDescription != "cancelled" {
                    appState.show(errorInfo: "网络请求异常")
                }
            }
        }
        .toolbar {
            ToolbarItem {
                Picker("类型", selection: $listType) {
                    Text("最新")
                        .tag(ExploreTopicType.latest)
                    Text("热门")
                        .tag(ExploreTopicType.hottest)
                }
                .pickerStyle(.segmented)
                .onChange(of: listType) { _ in
                    #if os(macOS)
                        appState.clearTopicSelection()
                    #endif
                    Task {
                        do {
                            switch listType {
                            case .latest:
                                latestTopics = try await V2EXClient.shared.getLatestTopics()
                            case .hottest:
                                hottestTopics = try await V2EXClient.shared.getHottestTopics()
                            }
                        } catch {
                            if error.localizedDescription != "cancelled" {
                                appState.show(errorInfo: "网络请求异常")
                            }
                        }
                    }
                }
            }
        }
    }

    var bgView: some View {
        showLoading ? AnyView(ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)) : AnyView(EmptyView())
    }

    var showLoading: Bool {
        switch listType {
        case .latest:
            return latestTopics.isEmpty
        case .hottest:
            return hottestTopics.isEmpty
        }
    }

    #if os(macOS)
        var listView: some View {
            List(selection: $appState.topicSelection) {
                switch listType {
                case .latest:
                    ForEach(latestTopics) {
                        SimpleTopicNavigationLinkView(topic: $0)
                    }
                case .hottest:
                    ForEach(hottestTopics) {
                        SimpleTopicNavigationLinkView(topic: $0)
                    }
                }
            }
            .listStyle(.sidebar)
            .task(id: appState.sidebarSelection) {
                guard appState.sidebarSelection == .main else {
                    return
                }
                latestTopics.removeAll()
                hottestTopics.removeAll()
                do {
                    switch listType {
                    case .latest:
                        latestTopics = try await V2EXClient.shared.getLatestTopics()
                    case .hottest:
                        hottestTopics = try await V2EXClient.shared.getHottestTopics()
                    }
                } catch {
                    if error.localizedDescription != "cancelled" {
                        appState.show(errorInfo: "网络请求异常")
                    }
                }
            }
        }
    #else
        var listView: some View {
            List {
                switch listType {
                case .latest:
                    ForEach(latestTopics) {
                        SimpleTopicNavigationLinkView(topic: $0)
                    }
                case .hottest:
                    ForEach(hottestTopics) {
                        SimpleTopicNavigationLinkView(topic: $0)
                    }
                }
            }
            .listStyle(.plain)
            .navigationDestination(for: String.self) { topicId in
                TopicView(topicId: topicId)
            }
            .task {
                do {
                    switch listType {
                    case .latest:
                        latestTopics = try await V2EXClient.shared.getLatestTopics()
                    case .hottest:
                        hottestTopics = try await V2EXClient.shared.getHottestTopics()
                    }
                } catch {
                    if error.localizedDescription != "cancelled" {
                        appState.show(errorInfo: "网络请求异常")
                    }
                }
            }
        }
    #endif
}

#if DEBUG
    struct ExploreView_Previews: PreviewProvider {
        static var previews: some View {
            ExploreView()
        }
    }
#endif
