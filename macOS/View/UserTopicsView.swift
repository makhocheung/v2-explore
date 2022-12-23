//
//  UserTopicsView.swift
//  V2 Explore (macOS)
//
//  Created by Mak Ho-Cheung on 2022/12/23.
//

import SwiftUI
import V2EXClient

struct UserTopicsView: View {
    let username: String
    @State var topicSelection: String?
    @State var topics: [Topic] = []
    @State var showLoading = true
    @EnvironmentObject var appState: AppState
    var body: some View {
        NavigationSplitView {
            ZStack {
                listView
                if showLoading {
                    bgView
                }
            }
        } detail: {
            TopicView()
                .navigationTitle("\(username) 的主题")
        }
        .task {
            do {
                topics = try await V2EXClient.shared.getTopicsByUser(username: username)
                showLoading.toggle()
            } catch {
                print(error)
            }
        }
    }

    var listView: some View {
        List(selection: $appState.topicSelection) {
            ForEach(topics) {
                SimpleTopicNavigationLinkView(topic: $0)
                    .padding(.vertical, 2)
            }
        }
        .listStyle(.sidebar)
    }

    @ViewBuilder
    var bgView: some View {
        if showLoading {
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            EmptyView()
        }
    }
}
