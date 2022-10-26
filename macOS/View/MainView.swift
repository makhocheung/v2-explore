//
//  MainView.swift
//  V2 Explore (macOS)
//
//  Created by Mak Ho-Cheung on 2022/9/2.
//

import SwiftUI
import V2EXClient

struct MainView: View {
    @EnvironmentObject var appState: AppState
    var body: some View {
        NavigationSplitView {
            SidebarView()
        } content: {
            ContentView()
                .navigationSplitViewColumnWidth(min: 250, ideal: 250)
        } detail: {
            TopicView()
        }
        .alert(appState.normalInfo, isPresented: $appState.isShowNormalInfo) {}
        .alert(appState.errorInfo, isPresented: $appState.isShowErrorInfo) {}
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
