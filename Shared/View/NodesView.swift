//
//  SubNodesView.swift
//  V2EX You (iOS)
//
//  Created by Mak Ho-Cheung on 2022/1/23.
//

import Kingfisher
import SwiftUI
import V2EXClient

struct NodesView: View {
    let parentNode: Node
    var body: some View {
        List(nodesByParent(name: parentNode.name), id: \.id) { it in
            NavigationLink {
                NodeView(node: it)
            } label: {
                HStack {
                    let img = it.avatarNormal
                    if img.starts(with: "/static") {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                    } else {
                        KFImage(URL(string: img))
                            .placeholder({ _ in
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                            })
                            .fade(duration: 0.25)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                    }
                    Text(it.title)
                }
            }
        }
        .navigationTitle(parentNode.title)
    }

    func nodesByParent(name: String) -> [Node] {
        return nodes.filter {
            $0.parentNodeName == name
        }
    }
}

#if DEBUG
struct SubNodesView_Previews: PreviewProvider {
    static var previews: some View {
        NodesView(parentNode: nodes[1])
    }
}
#endif
