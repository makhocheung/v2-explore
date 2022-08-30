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
    @State var navNodes: [String: [Node]]?
    var body: some View {
        List {
            ForEach(GlanceTopicType.allCases, id: \.self) { it in
                NavigationLink {
                    GlanceTopicsView(topicType: it)
                } label: {
                    HStack {
                        Text(LocalizedStringKey("glance." + it.rawValue))
                    }
                }
            }
            if let navNodes = navNodes {
                ForEach(Array(navNodes.keys.enumerated()), id: \.element) { _, key in
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
                navNodes = try await V2EXClient.shared.getNavNodeMap()
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
