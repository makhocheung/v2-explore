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
    @State var navigationNodes: [String: [Node]]?
    var body: some View {
        List {
            ForEach(GlanceType.allCases, id: \.self) { it in
                NavigationLink {
                    GlanceTopicsView(glanceType: it)
                } label: {
                    HStack {
                        Text(LocalizedStringKey("glance." + it.rawValue))
                    }
                }
            }
            if let navNodes = navigationNodes {
                ForEach(Array(navNodes.keys.sorted().enumerated()), id: \.element) { _, key in
                    Section {
                        ForEach(navNodes[key]!) { node in
                            NavigationLink {
                                NodeView(node: node)
                            } label: {
                                Text(node.title)
                            }
                        }
                    } header: {
                        Text("\(key)")
                            .font(.title3)
                    }
                }
            }
        }
        .task {
            do {
                navigationNodes = try await V2EXClient.shared.getNavigatinNodes()
            } catch {
                print(error)
            }
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
