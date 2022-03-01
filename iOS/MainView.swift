//
//  ContentView.swift
//  Shared
//
//  Created by Mak Ho-Cheung on 2021/11/23.
//

import SwiftUI

struct MainView: View {
    init() {
        UITableViewCell.appearance().backgroundColor = UIColor(Color("RootBackgroundColor"))
        UITableView.appearance().backgroundColor = UIColor(Color("RootBackgroundColor"))
    }

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

enum Tab {
    case home, nodes, profile

    var title: String {
        switch self {
        case .home:
            return "V2EX"
        case .nodes:
            return "节点"
        case .profile:
            return "我的"
        }
    }

    var tabItem: some View {
        switch self {
        case .home:
            return TabIcon(systemName: "house", title: "首页")
        case .nodes:
            return TabIcon(systemName: "square.grid.3x3.topleft.filled", title: "节点")
        case .profile:
            return TabIcon(systemName: "person", title: "我的")
        }
    }
}
