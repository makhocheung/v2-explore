//
//  NodesView.swift
//  V2EX You
//
//  Created by Mak Ho-Cheung on 2021/12/8.
//

import Kingfisher
import SwiftUI
import V2EXClient

struct GlanceView: View {
    let hierarchyNodes = ["apple", "fe", "programming", "dev", "ml", "games", "life", "internet", "cn"]

    var body: some View {
        List {
            ForEach(HOTTEST_NODES, id: \.self) { it in
                NavigationLink {
                    let node = parentNodes[it]!
                    GlanceTopicsView(node: node.name, title: node.title)
                } label: {
                    HStack {
                        KFImage(URL(string: parentNodes[it]!.avatarNormal))
                            .placeholder({ _ in
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                            })
                            .fade(duration: 0.25)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                        Text(parentNodes[it]!.title)
                    }
                }
            }
            Section {
                ForEach(hierarchyNodes, id: \.self) { it in
                    NavigationLink {
                        NodesView(parentNode: parentNodes[it]!)
                    } label: {
                        HStack {
                            KFImage(URL(string: parentNodes[it]!.avatarNormal))
                                .placeholder({ _ in
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFit()
                                })
                                .fade(duration: 0.25)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                            Text(parentNodes[it]!.title)
                        }
                    }
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

#if DEBUG
struct NodesView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GlanceView()
            GlanceView().preferredColorScheme(.dark)
        }
    }
}
#endif
