//
//  HomeView.swift
//  V2EX You
//
//  Created by Mak Ho-Cheung on 2021/11/23.
//

import SwiftUI

struct ExploreView: View {
    @State var listType = ExploreTopicType.latest
    @StateObject var latestTopicState = AppContext.shared.latestTopicsState
    @StateObject var hottestTopicState = AppContext.shared.hottestTopicsState
    var appAction = AppContext.shared.appAction
    var latestTopicsAction = AppContext.shared.latestTopicsAction
    var hottestTopicsAction = AppContext.shared.hottestTopicsAction

    var body: some View {
        List {
            Section {
                switch listType {
                case .latest:
                    ForEach(latestTopicState.topics) {
                        NavigationLinkView(topic: $0)
                    }
                case .hottest:
                    ForEach(hottestTopicState.topics) {
                        NavigationLinkView(topic: $0)
                    }
                }
            }
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
        }
        .background(bgView)
        .listStyle(.plain)
        .task {
            #if DEBUG

                switch listType {
                case .latest:
                    latestTopicsAction.updateTopics(topics: debugTopics)
                case .hottest:
                    hottestTopicsAction.updateTopics(topics: debugTopics)
                }
            #else
                do {
                    switch listType {
                    case .latest:
                        latestTopicsAction.updateTopics(topics: try await latestTopicsAction.getTopics())
                    case .hottest:
                        hottestTopicsAction.updateTopics(topics: try await hottestTopicsAction.getTopics())
                    }
                } catch {
                    if error.localizedDescription != "cancelled" {
                        print("[v2-explore]: \(error.localizedDescription)")
                        appAction.updateErrorMsg(errorMsg: "网络请求异常")
                        appAction.toggleIsShowErrorMsg()
                    }
                }
            #endif
        }
        .refreshable {
            do {
                switch listType {
                case .latest:
                    latestTopicsAction.updateTopics(topics: try await latestTopicsAction.refreshGetTopics())
                case .hottest:
                    hottestTopicsAction.updateTopics(topics: try await hottestTopicsAction.refreshGetTopics())
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
                    Task {
                        do {
                            switch listType {
                            case .latest:
                                latestTopicsAction.updateTopics(topics: try await latestTopicsAction.getTopics())
                            case .hottest:
                                hottestTopicsAction.updateTopics(topics: try await hottestTopicsAction.getTopics())
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
        ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#if DEBUG
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}
#endif
