//
//  SidebarView.swift
//  V2 Explore (macOS)
//
//  Created by Mak Ho-Cheung on 2022/9/8.
//

import SwiftUI
import V2EXClient

let MAIN_TAG = "main.explore"
let GLANCE_TAG_PREFIX = "glance."
let NODE_TAG_PREFIX = "node."

struct SidebarView: View {
    let navigationNodes = AppContext.shared.appState.navigationNodes
    @EnvironmentObject var navigationSelectionState: NavigationSelectionState
    var body: some View {
        List(selection: $navigationSelectionState.sidebarSelection) {
            Label("探索", systemImage: "newspaper.fill")
                .tag(SidebarTag.main)
            ForEach(GlanceType.allCases, id: \.self) { it in
                Label(LocalizedStringKey("glance." + it.rawValue), systemImage: it.icon)
                    .tag(SidebarTag.glance(it))
            }
            ForEach(Array(navigationNodes.keys.sorted().enumerated()), id: \.element) { _, key in
                Section {
                    ForEach(navigationNodes[key]!) { node in
                        Label(node.title, systemImage: "number.square")
                            .tag(SidebarTag.node(node))
                    }
                } header: {
                    Text("\(key)")
                        .font(.title3)
                }
            }
        }
        .listStyle(.sidebar)
        .onChange(of: navigationSelectionState.sidebarSelection) { _ in
            navigationSelectionState.topicSelection = nil
        }
    }
}

enum SidebarTag {
    case main, glance(GlanceType), node(Node)
}

extension SidebarTag: Equatable {
    static func == (lhs: SidebarTag, rhs: SidebarTag) -> Bool {
        switch lhs {
        case .main:
            switch rhs {
            case .main:
                return true
            default:
                return false
            }
        case let .glance(lhsGlanceType):
            switch rhs {
            case let .glance(rhsGlanceType):
                return lhsGlanceType == rhsGlanceType
            default:
                return false
            }
        case let .node(lhsNode):
            switch rhs {
            case let .node(rhsNode):
                return lhsNode.id == rhsNode.id
            default:
                return false
            }
        }
    }
}

extension SidebarTag: Hashable {
    func hash(into hasher: inout Hasher) {
        switch self {
        case .main:
            "main.explore".hash(into: &hasher)
        case let .glance(glanceType):
            return "glance.\(glanceType.rawValue)".hash(into: &hasher)
        case let .node(node):
            return node.title.hash(into: &hasher)
        }
    }
}
