//
//  LatestTopicsView.swift
//
//  Created by Mak Ho-Cheung on 2021/12/11.
//

import SwiftUI
import V2EXClient

struct GlanceTopicsView: View {
    @State var topics: [Topic] = []
    @EnvironmentObject var appState: AppState

    #if os(macOS)
        var glanceType: GlanceType? {
            switch appState.sidebarSelection {
            case let .glance(glanceType):
                return glanceType
            default:
                return nil
            }
        }

        var listView: some View {
            List(selection: $appState.topicSelection) {
                ForEach(topics) {
                    SimpleTopicNavigationLinkView(topic: $0)
                }
            }
            .listStyle(.sidebar)
            .task(id: appState.sidebarSelection) {
                topics.removeAll()
                do {
                    topics = try await V2EXClient.shared.getTopicsByTab(tab: glanceType!.rawValue)
                } catch {
                    if error.localizedDescription != "cancelled" {
                        appState.show(errorInfo: "info.network.error")
                    }
                }
            }
            .toolbar {
                ToolbarItem {
                    Button {
                        topics.removeAll()
                        appState.topicSelection = nil
                        Task {
                            do {
                                topics = try await V2EXClient.shared.getTopicsByTab(tab: glanceType!.rawValue)
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
                        appState.show(errorInfo: "info.network.error")
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
    #if os(iOS)
        struct GlanceTopicsView_Previews: PreviewProvider {
            static var previews: some View {
                GlanceTopicsView(glanceType: nil)
            }
        }
    #endif
#endif
