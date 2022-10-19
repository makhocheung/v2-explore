//
//  ContentView.swift
//  Shared
//
//  Created by Mak Ho-Cheung on 2021/11/23.
//

import SwiftUI

struct MainView: View {
    @StateObject var appState = AppContext.shared.appState

    var body: some View {
        TabView {
            NavigationStack {
                ExploreView()
                    .navigationTitle("探索")
            }
            .tabItem {
                Label("探索", systemImage: "newspaper.fill")
            }
            NavigationStack {
                GlanceView()
                    .navigationTitle("浏览")
            }
            .tabItem {
                Label("浏览", systemImage: "rectangle.stack.fill")
            }
            NavigationStack {
                ProfileView()
                    .navigationTitle("我的")
            }
            .tabItem {
                Label("我的", systemImage: "person.circle.fill")
            }
        }
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

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MainView()
            MainView()
                .preferredColorScheme(.dark)
        }
    }
}
#endif
