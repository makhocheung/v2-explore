//
//  ContentView.swift
//  Shared
//
//  Created by Mak Ho-Cheung on 2021/11/23.
//

import SwiftUI

struct MainView: View {
    @State var selectedTabItemType = TabItemType.home
    var body: some View {
        NavigationView {
            TabView(selection: $selectedTabItemType) {
                HomeView()
                    .tabItem {
                        TabItemType.home.tabItem
                    }
                    .tag(TabItemType.home)
                NodesView()
                    .tabItem {
                        TabItemType.nodes.tabItem
                    }
                    .tag(TabItemType.nodes)
                ProfileView()
                    .tabItem {
                        TabItemType.profile.tabItem
                    }
                    .tag(TabItemType.profile)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        Text(selectedTabItemType.rawValue)
                            .foregroundColor(.accentColor)
                            .font(.title2)
                            .bold()
                        if selectedTabItemType == .home {
                            NavigationLink {
                                Text("empty")
                            } label: {
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(Color("InputTextColor"))
                                    Text("搜索")
                                        .foregroundColor(Color("InputTextColor"))
                                }
                                .padding(6)
                                .frame(width: UIScreen.main.bounds.width / 1.5, alignment: .leading)
                                .background(Color("InputColor"))
                                .cornerRadius(20)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    if selectedTabItemType == .home {
                        Button {
                        } label: {
                            Image(systemName: "plus")
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

enum TabItemType: String {
    case home = "首页", nodes = "节点", profile = "我的"

    var tabItem: some View {
        switch self {
        case .home:
            return Label(self.rawValue, systemImage: "house")
        case .nodes:
            return Label(self.rawValue, systemImage: "square.grid.3x3.topleft.filled")
        case .profile:
            return Label(self.rawValue, systemImage: "person")
        }
    }
}
