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
                .navigationSplitViewColumnWidth(min: 270, ideal: 270)
        } detail: {
            TopicView()
        }
        .sheet(isPresented: $appState.isShowLoginView) {
            SignInView()
        }
        .sheet(item: $appState.userProfileSelection) {
            UserProfileView(username: $0.username,useHomeData: $0.isLoginUser)
        }
        .alert(LocalizedStringKey(appState.normalInfo), isPresented: $appState.isShowNormalInfo) {}
        .alert(LocalizedStringKey(appState.errorInfo), isPresented: $appState.isShowErrorInfo) {}
        .onOpenURL { url in
            appState.sidebarSelection = .main
            appState.topicSelection = url.lastPathComponent
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
