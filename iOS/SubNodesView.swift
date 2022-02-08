//
//  SubNodesView.swift
//  V2EX You (iOS)
//
//  Created by Mak Ho-Cheung on 2022/1/23.
//

import Kingfisher
import SwiftUI

struct SubNodesView: View {
    let parentNode: Node
    var body: some View {
        List(nodesByParent(name: parentNode.name), id: \.id) { it in
            NavigationLink {
                NodeView(node: it)
            } label: {
                HStack {
                    let img = it.avatarNormal
                    if img.starts(with: "/static") {
                        Rectangle()
                            .frame(width: 30, height: 30)
                            .background(Color.blue)
                    } else {
                        KFImage(URL(string: img))
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                    Text(it.title)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(parentNode.title)
            }
        }
        .navigationTitle("")
    }

    func nodesByParent(name: String) -> [Node] {
        return nodes.filter {
            $0.parentNodeName == name
        }
    }
}

struct SubNodesView_Previews: PreviewProvider {
    static var previews: some View {
        SubNodesView(parentNode: nodes[1])
    }
}
