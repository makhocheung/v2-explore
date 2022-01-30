//
//  ContentView.swift
//  Shared
//
//  Created by Mak Ho-Cheung on 2021/11/23.
//

import SwiftUI

struct MainView: View {
    @State var selectedTab = Tab.home
    var body: some View {
        NavigationView {
            ZStack {
                HomeView()
                    .zIndex(selectedTab == .home ? .infinity : 0)
                NodesView()
                    .zIndex(selectedTab == .nodes ? .infinity : 0)
                ProfileView()
                    .zIndex(selectedTab == .profile ? .infinity : 0)
            }
            .navigationBarTitle("")
            .safeAreaInset(edge: .bottom, spacing: 0) {
                HStack {
                    Tab.home.tabItem
                        .opacity(selectedTab == .home ? 1 : 0.5)
                        .onTapGesture {
                            selectedTab = .home
                        }
                    Spacer()
                    Tab.nodes.tabItem
                        .opacity(selectedTab == .nodes ? 1 : 0.5)
                        .onTapGesture {
                            selectedTab = .nodes
                        }
                    Spacer()
                    Tab.profile.tabItem
                        .opacity(selectedTab == .profile ? 1 : 0.5)
                        .onTapGesture {
                            selectedTab = .profile
                        }
                }
                .font(.title3)
                .padding(.vertical, 7)
                .padding(.horizontal, 60)
                .background(.regularMaterial)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(selectedTab.title)
                        .font(.title2)
                        .bold()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    if selectedTab == .home {
                        Button {
                        } label: {
                            Image(systemName: "plus")
                                .foregroundColor(.accentColor)
                        }
                    }
                }
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
