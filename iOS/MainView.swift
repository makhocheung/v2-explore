//
//  ContentView.swift
//  Shared
//
//  Created by Mak Ho-Cheung on 2021/11/23.
//

import SwiftUI

struct MainView: View {
    @StateObject var errorStore = AppStore.errorStore

    var body: some View {
        TabView {
            NavigationView {
                ExploreView()
                    .navigationTitle("探索")
            }
            .navigationViewStyle(.stack)
            .tabItem {
                Label("探索", systemImage: "newspaper.fill")
            }
            NavigationView {
                GlanceView()
                    .navigationTitle("浏览")
            }
            .navigationViewStyle(.stack)
            .tabItem {
                Label("浏览", systemImage: "rectangle.stack.fill")
            }
            NavigationView {
                ProfileView()
                    .navigationTitle("我的")
            }
            .navigationViewStyle(.stack)
            .tabItem {
                Label("我的", systemImage: "person.circle.fill")
            }
        }
        .alert(errorStore.errorMsg, isPresented: $errorStore.isShowError) {
            Button("完成") {
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MainView()
            MainView()
                .preferredColorScheme(.dark)
        }
    }
}
