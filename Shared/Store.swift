//
//  Store.swift
//  V2EX You
//
//  Created by Mak Ho-Cheung on 2022/2/8.
//

import Foundation
import SwiftUI

class PreferNodesState: ObservableObject {
    static let shared = PreferNodesState()

    @Published var preferNodes: [PreferNode]
    @Published var w: [CGFloat]

    var tmpPreferNodes: [SimplePreferNode] = [] // 解决 SwiftUI 的导航组件 Bug
    private var readyForDeleteIndexs: [Int] = []

    init() {
        let storedPreferNodes = PreferNodesState.getPreferNodes()
        w = Array(repeating: CGFloat.zero, count: 2 + storedPreferNodes.count)
        preferNodes = [.latestPreferNode, .hotPreferNode]
        preferNodes.append(contentsOf: storedPreferNodes)
    }

    func refresh() {
        guard !tmpPreferNodes.isEmpty else {
            return
        }
        let nodes = tmpPreferNodes.map { PreferNode(title: $0.title, id: $0.id) }
        preferNodes.append(contentsOf: nodes)
        w.append(contentsOf: Array(repeating: 0.0, count: nodes.count))
        tmpPreferNodes.removeAll()
    }

    func addToDelete(index: Int) {
        readyForDeleteIndexs.append(index)
    }

    func batchDelete() {
        guard !readyForDeleteIndexs.isEmpty else {
            return
        }
        readyForDeleteIndexs.forEach {
            preferNodes.remove(at: $0)
            w.remove(at: $0)
        }
        readyForDeleteIndexs.removeAll()
        PreferNodesState.savePreferNodes()
    }

    static func getPreferNodes() -> [PreferNode] {
        guard let data = UserDefaults.standard.data(forKey: "PreferNodes") else {
            return []
        }
        let simplePreferNodes = try! JSONDecoder().decode([SimplePreferNode].self, from: data)
        return simplePreferNodes.map { PreferNode(title: $0.title, id: $0.id) }
    }

    static func savePreferNodes() {
        var nodes: [SimplePreferNode] = PreferNodesState.shared.preferNodes
            .filter { $0 != .latestPreferNode && $0 != .hotPreferNode }
            .map { SimplePreferNode(id: $0.id, title: $0.title) }
        nodes.append(contentsOf: PreferNodesState.shared.tmpPreferNodes)
        let json = try! JSONEncoder().encode(nodes)
        UserDefaults.standard.set(json, forKey: "PreferNodes")
    }
}

class TopicsState: ObservableObject {
    @Published var topics: [Topic] = []

    var preferNode: PreferNode!
}
