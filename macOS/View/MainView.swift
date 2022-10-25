//
//  MainView.swift
//  V2 Explore (macOS)
//
//  Created by Mak Ho-Cheung on 2022/9/2.
//

import SwiftUI
import V2EXClient

struct MainView: View {
    @StateObject var appState = AppContext.shared.appState
    @StateObject var navigationSelectionState = NavigationSelectionState()
    var body: some View {
        NavigationSplitView {
            SidebarView()
        } content: {
            ContentView()
                .navigationSplitViewColumnWidth(min: 250, ideal: 250)
        } detail: {
            TopicView()
        }
        .environmentObject(navigationSelectionState)
        .alert(appState.errorMsg, isPresented: $appState.isShowErrorMsg) {
            Button("完成") {
            }
        }
        .alert(appState.tips, isPresented: $appState.isShowTips) {
            Button("完成") {
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
