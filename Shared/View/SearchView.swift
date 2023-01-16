//
//  SearchView.swift
//  V2 Explore
//
//  Created by Mak Ho-Cheung on 2023/1/16.
//

import SwiftUI
import V2EXClient

struct SearchView: View {
    @EnvironmentObject var appState: AppState
    var body: some View {
        ZStack {
            if appState.searching {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let hits = appState.searchResult?.hits {
                List(selection: $appState.topicSelection) {
                    ForEach(hits) { it in
                        Text(it.source.title ?? "空")
                            .tag(String(it.source.id))
                    }
                }
                .listStyle(.sidebar)
            } else {
                if appState.searchContent.isEmpty {
                    Text("No content")
                } else {
                    Button {
                        appState.search()
                    } label: {
                        Label("执行搜索关键字：\(appState.searchContent)", systemImage: "magnifyingglass")
                            .lineLimit(1)
                    }
                    .foregroundColor(.accentColor)
                    .buttonStyle(.plain)
                    .padding(.horizontal)
                }
            }
        }
        .toolbar {
            ToolbarItem {
                if let hits = appState.searchResult?.hits {
                    Button {
                        appState.search()
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
