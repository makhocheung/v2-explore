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
    var appAction = AppContext.shared.appAction
    #if os(macOS)
        @EnvironmentObject var navigationSelectionState: NavigationSelectionState
    #endif
    var body: some View {
        ZStack {
            listView
            if showLoading {
                bgView
            }
        }
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
                    print("[v2-explore]: \(error.localizedDescription)")
                    appAction.updateErrorMsg(errorMsg: "网络请求异常")
                    appAction.toggleIsShowErrorMsg()
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
                        navigationSelectionState.topicSelection = nil
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
                                print("[v2-explore]: \(error.localizedDescription)")
                                appAction.updateErrorMsg(errorMsg: "网络请求异常")
                                appAction.toggleIsShowErrorMsg()
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
            List(selection: $navigationSelectionState.topicSelection) {
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
            .task(id: navigationSelectionState.sidebarSelection) {
                guard navigationSelectionState.sidebarSelection == .main else {
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
    struct ExploreView_Previews: PreviewProvider {
        static var previews: some View {
            ExploreView()
        }
    }
#endif
