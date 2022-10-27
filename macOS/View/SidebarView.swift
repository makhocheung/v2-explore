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
    @EnvironmentObject var appState: AppState
    @State var searchText = ""
    var body: some View {
        List(selection: $appState.sidebarSelection) {
            Section {
                if isContainExplore {
                    Label("common.explore", systemImage: "newspaper.fill")
                        .tag(SidebarTag.main)
                }
                ForEach(filteredGlanceTypes, id: \.self) { it in
                    Label(LocalizedStringKey("glance." + it.rawValue), systemImage: it.icon)
                        .tag(SidebarTag.glance(it))
                }
            } header: {
                Text("common.glance")
                    .font(.title3)
            }
            if searchText.isEmpty {
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
            } else {
                ForEach(filteredNavNodes) { node in
                    Label(node.title, systemImage: "number.square")
                        .tag(SidebarTag.node(node))
                }
            }
        }
        .listStyle(.sidebar)
        .searchable(text: $searchText, placement: SearchFieldPlacement.sidebar, prompt: Text("search.nodes"))
        .onChange(of: appState.sidebarSelection) { _ in
            appState.topicSelection = nil
        }
    }

    var filteredGlanceTypes: [GlanceType] {
        if searchText.isEmpty {
            return GlanceType.allCases
        } else {
            return GlanceType.allCases.filter { it in
                String(localized: LocalizedStringResource(stringLiteral: "glance." + it.rawValue)).contains(searchText)
            }
        }
    }

    var filteredNavNodes: [Node] {
        navigationNodes.flatMap { $1 }.filter { it in
            it.title.contains(searchText)
        }
    }

    var navigationNodes: [String: [Node]] {
        appState.navigationNodes
    }

    var isContainExplore: Bool {
        searchText.isEmpty || String(localized: LocalizedStringResource(stringLiteral: "common.explore")).contains(searchText)
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
