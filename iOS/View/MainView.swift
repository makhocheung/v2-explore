//
//  ContentView.swift
//  Shared
//
//  Created by Mak Ho-Cheung on 2021/11/23.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        TabView {
            NavigationStack {
                ExploreView()
                    .navigationTitle("common.explore")
            }
            .tabItem {
                Label("common.explore", systemImage: "newspaper.fill")
            }
            NavigationStack {
                GlanceView()
                    .navigationTitle("common.glance")
            }
            .tabItem {
                Label("common.glance", systemImage: "rectangle.stack.fill")
            }
            NavigationStack {
                ProfileView()
                    .navigationTitle("common.profile")
            }
            .tabItem {
                Label("common.profile", systemImage: "person.circle.fill")
            }
        }
        .alert(LocalizedStringKey(appState.errorInfo), isPresented: $appState.isShowErrorInfo) {}
        .alert(LocalizedStringKey(appState.normalInfo), isPresented: $appState.isShowNormalInfo) {}
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
