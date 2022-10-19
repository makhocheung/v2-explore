//
//  NodesView.swift
//  V2EX You
//
//  Created by Mak Ho-Cheung on 2021/12/8.
//

import Foundation
import Kingfisher
import SwiftUI
import V2EXClient

struct GlanceView: View {
    let navNodes = AppContext.shared.appState.navigationNodes
    @State var searchText = ""
    var body: some View {
        List {
            ForEach(filteredGlanceTypes, id: \.self) { it in
                NavigationLink(value: it) {
                    HStack {
                        Text(LocalizedStringKey("glance." + it.rawValue))
                    }
                }
            }
            if searchText.isEmpty {
                ForEach(Array(navNodes.keys.sorted().enumerated()), id: \.element) { _, key in
                    Section {
                        ForEach(navNodes[key]!) { node in
                            NavigationLink(value: node) {
                                Text(node.title)
                            }
                        }
                    } header: {
                        Text("\(key)")
                            .font(.title3)
                    }
                }
            } else {
                ForEach(filteredNavNodes) { node in
                    NavigationLink(value: node) {
                        Text(node.title)
                    }
                }
            }
        }
        .searchable(text: $searchText, prompt: Text("搜索节点"))
        .navigationDestination(for: GlanceType.self) {
            GlanceTopicsView(glanceType: $0)
        }
        .navigationDestination(for: Node.self) {
            NodeView(node: $0)
        }
    }

    var filteredGlanceTypes: [GlanceType] {
        if searchText.isEmpty {
            return GlanceType.allCases
        } else {
            return GlanceType.allCases.filter { it in
                return String(localized: LocalizedStringResource(stringLiteral: "glance." + it.rawValue)).contains(searchText)
            }
        }
    }
    
    var filteredNavNodes: [Node] {
        navNodes.flatMap { _,v in
             v
        }.filter { it in
            it.title.contains(searchText)
        }
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
