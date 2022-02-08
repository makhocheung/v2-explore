//
//  NodesView.swift
//  V2EX You
//
//  Created by Mak Ho-Cheung on 2021/12/8.
//

import Kingfisher
import SwiftUI

struct NodesView: View {
    let hierachyNodes = ["apple", "fe", "programming", "dev", "ml", "games", "life", "internet", "cn"]
    let hotNodes = ["qna", "jobs", "programmer", "share", "macos", "apple", "create", "python", "career", "bb", "android", "iphone", "gts", "mbp", "cv"]

    init() {
        UITableViewCell.appearance().backgroundColor = UIColor(Color("RootBackgroundColor"))
        UITableView.appearance().backgroundColor = UIColor(Color("RootBackgroundColor"))
    }

    var body: some View {
        VStack(spacing: 0) {
            Divider()
            List {
                Section {
                    ForEach(hotNodes, id: \.self) { it in
                        NavigationLink {
                            NodeView(node: parentNodes[it]!)
                        } label: {
                            HStack {
                                let img = parentNodes[it]!.avatarNormal

                                if img.starts(with: "/static") {
                                    Rectangle()
                                        .frame(width: 30, height: 30)
                                        .background(Color.blue)
                                } else {
                                    KFImage(URL(string: img))
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                }
                                Text(parentNodes[it]!.title)
                            }
                        }
                    }
                    .listRowBackground(Color("ContentBackgroundColor"))
                } header: {
                    Text("最热节点")
                }

                Section {
                    ForEach(hierachyNodes, id: \.self) { it in
                        NavigationLink {
                            SubNodesView(parentNode: parentNodes[it]!)
                        } label: {
                            HStack {
                                KFImage(URL(string: parentNodes[it]!.avatarNormal))
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                Text(parentNodes[it]!.title)
                            }
                        }
                    }
                    .listRowBackground(Color("ContentBackgroundColor"))
                } header: {
                    Text("节点导航")
                }

                NavigationLink {
                    Text("所有节点")
                } label: {
                    Text("所有节点")
                }
                .listRowBackground(Color("ContentBackgroundColor"))
            }
        }
    }

    var parentNodes: [String: Node] {
        return Dictionary(uniqueKeysWithValues: nodes.map { ($0.name, $0) })
    }
}

struct NodesView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                NodesView()
                    .navigationTitle("")
                    .navigationBarTitleDisplayMode(.inline)
            }
            .navigationBarTitleDisplayMode(.inline)
            NodesView().preferredColorScheme(.dark)
        }
    }
}
