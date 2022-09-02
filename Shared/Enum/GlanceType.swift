//
//  GlanceTopicType.swift
//  V2 Explore
//
//  Created by Mak Ho-Cheung on 2022/8/30.
//

import Foundation

enum GlanceType: String, CaseIterable {
    case all, tech, creative, play, apple, jobs, deals, city, qna, nodes

    var icon: String {
        switch self {
        case .all:
            return "square.grid.3x3.square"
        case .tech:
            return "pc"
        case .creative:
            return "pencil.circle"
        case .play:
            return "play"
        case .apple:
            return "apple.logo"
        case .jobs:
            return "folder.circle"
        case .deals:
            return "arrow.up.arrow.down.circle"
        case .city:
            return "globe.asia.australia"
        case .qna:
            return "questionmark.circle"
        case .nodes:
            return "square.grid.3x1.below.line.grid.1x2.fill"
        }
    }
}
