//
//  LatestTopicsView.swift
//  V2EX You
//
//  Created by Mak Ho-Cheung on 2021/12/11.
//

import SwiftUI

struct GlanceTopicsView: View {
    let node: String
    let title: String
    @State var topics: [Topic] = []

    init(node: String, title: String) {
        self.node = node
        self.title = title
    }

    var body: some View {
        List {
            Section {
                ForEach(topics) {
                    NavigationLinkView(topic: $0)
                }
            }
            .listRowInsets(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .navigationTitle(title)
        .task {
            do {
                topics = try await APIService.shared.getTopicsByNode(nodeName: node)
            } catch {
                print(error)
            }
        }
        .background(bgView)
    }

    var bgView: some View {
        ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct LatestTopicsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            GlanceTopicsView(node: "qna", title: "问与答")
        }
    }
}
