//
//  ContentView.swift
//  V2 Explore (macOS)
//
//  Created by Mak Ho-Cheung on 2022/9/8.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    var body: some View {
        if let sidebarSelection = appState.sidebarSelection {
            switch sidebarSelection {
            case .main:
                ExploreView()
            case .glance:
                GlanceTopicsView()
            case .nodes:
                NodeView()
            case .search:
                SearchView()
            }
        } else {
            Text("No content")
                .toolbar {
                    ToolbarItem {
                        Text("V2 Explore")
                    }
                }
        }
    }
}
