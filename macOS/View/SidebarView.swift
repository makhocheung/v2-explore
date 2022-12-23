//
//  SidebarView.swift
//  V2 Explore (macOS)
//
//  Created by Mak Ho-Cheung on 2022/9/8.
//

import Kingfisher
import SwiftUI
import V2EXClient

struct SidebarView: View {
    @EnvironmentObject var appState: AppState
    @State var userProfileSelection: UserProfileSelection?

    var body: some View {
        VStack {
            if let user = appState.user {
                Button {
                    userProfileSelection = UserProfileSelection(isLoginUser: true, username: user.name)
                } label: {
                    KFImage(URL(string: user.avatar)!)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50)
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
                .popover(item: $userProfileSelection) {
                    UserProfileView(username: $0.username,useHomeData: $0.isLoginUser)
                }
            } else {
                Button {
                    appState.isShowLoginView.toggle()
                } label: {
                    ZStack {
                        HStack {
                            Image(systemName: "person.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 25)
                            Text("common.signIn")
                        }
                    }
                    .frame(height: 50)
                }
                .buttonStyle(.borderless)
            }
            List(selection: $appState.sidebarSelection) {
                Section {
                    Label("common.explore", systemImage: "newspaper.fill")
                        .tag(SidebarTag.main)
                    ForEach(GlanceType.allCases, id: \.self) { it in
                        Label(LocalizedStringKey("glance." + it.rawValue), systemImage: it.icon)
                            .tag(SidebarTag.glance(it))
                    }
                } header: {
                    Text("common.hot")
                }
                Section {
                    Label("common.nodes", systemImage: "square.grid.3x1.below.line.grid.1x2.fill")
                        .tag(SidebarTag.nodes)
//                    Label("搜索", systemImage: "magnifyingglass.circle")
//                        .tag(SidebarTag.nodes)
                } header: {
                    Text("common.glance")
                }
            }
            .listStyle(.sidebar)
        }

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
