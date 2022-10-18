//
//  NodesView.swift
//  V2EX You
//
//  Created by Mak Ho-Cheung on 2021/12/8.
//

import Kingfisher
import SwiftUI
import V2EXClient
import Foundation

struct GlanceView: View {
    let navNodes = AppContext.shared.appState.navigationNodes
    var body: some View {
        List {
            ForEach(GlanceType.allCases, id: \.self) { it in
                NavigationLink(value: it) {
                    HStack {
                        Text(LocalizedStringKey("glance." + it.rawValue))
                    }
                }
            }
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
        }
        .navigationDestination(for: GlanceType.self) {
            GlanceTopicsView(glanceType: $0)
        }
        .navigationDestination(for: Node.self) {
            NodeView(node: $0)
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
