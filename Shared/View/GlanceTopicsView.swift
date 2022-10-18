//
//  LatestTopicsView.swift
//
//  Created by Mak Ho-Cheung on 2021/12/11.
//

import SwiftUI
import V2EXClient

struct GlanceTopicsView: View {
    @State var topics: [Topic] = []
    var appAction = AppContext.shared.appAction

    #if os(macOS)
        @EnvironmentObject var navigationSelectionState: NavigationSelectionState
        var glanceType: GlanceType? {
            switch navigationSelectionState.sidebarSelection {
            case let .glance(glanceType):
                return glanceType
            default:
                return nil
            }
        }

        var listView: some View {
            List(selection: $navigationSelectionState.topicSelection) {
                ForEach(topics) {
                    SimpleTopicNavigationLinkView(topic: $0)
                }
            }
            .listStyle(.sidebar)
            .task(id: navigationSelectionState.sidebarSelection) {
                topics = []
                do {
                    topics = try await V2EXClient.shared.getTopicsByTab(tab: glanceType!.rawValue)
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
        let glanceType: GlanceType?
        var listView: some View {
            List {
                ForEach(topics) {
                    SimpleTopicNavigationLinkView(topic: $0)
                }
            }
            .listStyle(.plain)
            .navigationDestination(for: String.self) {
                TopicView(topicId: $0)
            }
            .task {
                do {
                    topics = try await V2EXClient.shared.getTopicsByTab(tab: glanceType?.rawValue)
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

    var body: some View {
        if let glanceType {
            ZStack {
                listView
                bgView
            }
            .navigationTitle(LocalizedStringKey("glance." + glanceType.rawValue))
        } else {
            EmptyView()
        }
    }

    var bgView: some View {
        topics.isEmpty ? AnyView(ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)) : AnyView(EmptyView())
    }
}

#if DEBUG
    struct GlanceTopicsView_Previews: PreviewProvider {
        static var previews: some View {
            GlanceTopicsView(glanceType: nil)
        }
    }
#endif
