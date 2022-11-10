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
    @State var visibility: NavigationSplitViewVisibility = .all

    var body: some View {
        NavigationSplitView(columnVisibility: $visibility) {
            SidebarView()
        } content: {
            ContentView()
                .navigationSplitViewColumnWidth(min: 250, ideal: 250)
        } detail: {
            TopicView()
        }
        .alert(LocalizedStringKey(appState.normalInfo), isPresented: $appState.isShowNormalInfo) {}
        .alert(LocalizedStringKey(appState.errorInfo), isPresented: $appState.isShowErrorInfo) {}
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
