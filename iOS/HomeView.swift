//
//  HomeView.swift
//  V2EX You
//
//  Created by Mak Ho-Cheung on 2021/11/23.
//

import SwiftUI

struct HomeView: View {
    @State var tabSelection = 0
    @StateObject var preferNodesState = PreferNodesState.shared
    var body: some View {
        VStack {
            ScrollableTabView(activeIdx: $tabSelection)
                .padding(.top, 10)
                .foregroundColor(.accentColor)
//            HStack {
//                ForEach(0 ..< preferNodesState.preferNodes.count, id: \.self) { index in
//                    if tabSelection == index {
//                        Text(preferNodesState.preferNodes[index].title)
//                            .padding(4)
//                            .background(Color("StressBackgroundColor"))
//                            .foregroundColor(Color("StressTextColor"))
//                            .cornerRadius(5)
//
//                    } else {
//                        Text(preferNodesState.preferNodes[index].title)
//                            .padding(4)
//                            .foregroundColor(Color.accentColor)
//                            .onTapGesture {
//                                tabSelection = index
            ////                                preferNodesState.currentPreferNode = preferNodesState.preferNodes[tabSelection]
            ////                                preferNodesState.currentPreferNode.topicsState.topics.removeAll()
            ////                                do {
            ////                                    try preferNodesState.currentPreferNode.topicsState.getTopics()
            ////                                } catch {
            ////                                    print("\(error)")
            ////                                    showError.toggle()
            ////                                }
//                            }
//                    }
//                }
//                Spacer()
//            }

            TabView(selection: $tabSelection) {
                ForEach(0 ..< preferNodesState.preferNodes.count, id: \.self) { index in
                    TopicsView(topicsState: preferNodesState.preferNodes[index].topicsState)
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
        .background(Color("RootBackgroundColor"))
        .onAppear {
            preferNodesState.refresh()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
