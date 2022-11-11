//
//  NodesSelectionView.swift
//  V2 Explore (macOS)
//
//  Created by Mak Ho-Cheung on 2022/11/11.
//

import SwiftUI
import V2EXClient

struct NodesSelectionView: View {
    @EnvironmentObject var appState: AppState
    @Binding var node: Node?
    @State var nodeSelection: Node?
    @Environment(\.dismiss) var dismissAction
    @State var searchText = ""
    @FocusState private var focusState: FocusTag?

    var body: some View {
        VStack {
            HStack {
                TextField("search.nodes", text: $searchText)
                    .focused($focusState, equals: .textFiled)
                    .frame(width: 200)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top)
            Divider()
            List(selection: $nodeSelection) {
                if searchText.isEmpty {
                    ForEach(Array(appState.navigationNodes.keys.sorted().enumerated()), id: \.element) { _, key in
                        Section {
                            ForEach(appState.navigationNodes[key]!) {
                                Label($0.title, systemImage: "number.square")
                                    .font(.title3)
                                    .tag($0)
                            }
                        } header: {
                            Text("\(key)")
                                .font(.title3)
                        }
                    }
                } else {
                    ForEach(filteredNavNodes) {
                        Label($0.title, systemImage: "number.square")
                            .tag($0)
                    }
                }
            }
            .focused($focusState, equals: .list)
            .scrollContentBackground(.hidden)
            Divider()
            HStack {
                Button("取消") {
                    dismissAction()
                }
                Spacer()
                Button("完成") {
                    node = nodeSelection
                    appState.topicSelection = nil
                    dismissAction()
                }
            }
            .padding(.horizontal)
        }
        .padding(.bottom)
        .frame(width: 400, height: 500)
        .background(.regularMaterial)
        .onAppear {
            nodeSelection = node
            focusState = .list
        }
    }

    var filteredNavNodes: [Node] {
        appState.navigationNodes.flatMap { $1 }.filter { it in
            it.title.contains(searchText)
        }
    }
}

fileprivate enum FocusTag {
    case textFiled, list
}
