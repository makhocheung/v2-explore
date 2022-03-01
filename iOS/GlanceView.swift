//
//  NodesView.swift
//  V2EX You
//
//  Created by Mak Ho-Cheung on 2021/12/8.
//

import Kingfisher
import SwiftUI

struct GlanceView: View {
    let hierachyNodes = ["apple", "fe", "programming", "dev", "ml", "games", "life", "internet", "cn"]

    var body: some View {
        List {
            ForEach(AppStore.HOTTEST_NODES, id: \.self) { it in
                NavigationLink {
                    let node = parentNodes[it]!
                    GlanceTopicsView(node: node.name, title: node.title)
                } label: {
                    HStack {
                        KFImage(URL(string: parentNodes[it]!.avatarNormal))
                            .resizable()
                            .frame(width: 30, height: 30)
                        Text(parentNodes[it]!.title)
                    }
                }
                .listRowBackground(Color("ContentBackgroundColor"))
            }
            Section {
                ForEach(hierachyNodes, id: \.self) { it in
                    NavigationLink {
                        NodesView(parentNode: parentNodes[it]!)
                    } label: {
                        HStack {
                            KFImage(URL(string: parentNodes[it]!.avatarNormal))
                                .resizable()
                                .frame(width: 30, height: 30)
                            Text(parentNodes[it]!.title)
                        }
                    }
                    .listRowBackground(Color("ContentBackgroundColor"))
                }
            } header: {
                Text("导航")
                    .font(.title3)
            }
        }
        .listStyle(.grouped)
    }

    var parentNodes: [String: Node] {
        return Dictionary(uniqueKeysWithValues: nodes.map { ($0.name, $0) })
    }
}

struct NodesView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GlanceView()
            GlanceView().preferredColorScheme(.dark)
        }
    }
}
