//
//  SidebarView.swift
//  V2 Explore (macOS)
//
//  Created by Mak Ho-Cheung on 2022/9/8.
//

import SwiftUI
import V2EXClient

struct SidebarView: View {
    @EnvironmentObject var appState: AppState
    var body: some View {
        List(selection: $appState.sidebarSelection) {
            Section {
                Label("common.explore", systemImage: "newspaper.fill")
                    .tag(SidebarTag.main)
                ForEach(GlanceType.allCases, id: \.self) { it in
                    Label(LocalizedStringKey("glance." + it.rawValue), systemImage: it.icon)
                        .tag(SidebarTag.glance(it))
                }
                Label("common.nodes", systemImage: "square.grid.3x1.below.line.grid.1x2.fill")
                    .tag(SidebarTag.nodes)
            }
        }
        .listStyle(.sidebar)
        .onChange(of: appState.sidebarSelection) { _ in
            appState.topicSelection = nil
        }
    }
}

enum SidebarTag {
    case main, glance(GlanceType), nodes
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
        case .nodes:
            switch rhs {
            case .nodes:
                return true
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
            "common.explore".hash(into: &hasher)
        case let .glance(glanceType):
            return "glance.\(glanceType.rawValue)".hash(into: &hasher)
        case .nodes:
            "common.nodes".hash(into: &hasher)
        }
    }
}
