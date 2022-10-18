//
//  ContentView.swift
//  V2 Explore (macOS)
//
//  Created by Mak Ho-Cheung on 2022/9/8.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var navigationSelectionState: NavigationSelectionState
    var body: some View {
        if let sidebarSelection = navigationSelectionState.sidebarSelection {
            switch sidebarSelection {
            case .main:
                ExploreView()
            case .glance:
                GlanceTopicsView()
            case .node:
                NodeView()
            }
        } else {
            Text("No content")
        }
    }
}
