//
//  LatestTopicsView.swift
//  V2EX You
//
//  Created by Mak Ho-Cheung on 2021/12/11.
//

import SwiftUI

struct TopicsView: View {
    @StateObject var topicsState: TopicsState
    @State var showError = false

    init(topicsState: TopicsState) {
        _topicsState = StateObject(wrappedValue: topicsState)
    }

    var body: some View {
        RefreshableScrollView(onRefresh: { done in
            Task {
                do {
                    topicsState.topics = try await APIService.shared.getTopics(topicsState.preferNode)
                    done()
                } catch {
                    print("\(error)")
                    done()
                    showError.toggle()
                }
            }
        }) {
            VStack {
                ForEach(0 ..< topicsState.topics.count, id: \.self) { index in
                    if index == 0 {
                        Divider()
                    }
                    NavigationLinkView(topic: topicsState.topics[index])
                    Divider()
                }
            }
        }
        .background(bgView)
        .task {
            guard topicsState.topics.isEmpty else {
                return
            }
            do {
                topicsState.topics = try await APIService.shared.getTopics(topicsState.preferNode)
            } catch {
                print("\(error)")
                showError.toggle()
            }
        }
    }

    var bgView: some View {
        topicsState.topics.isEmpty ? AnyView(ProgressView()) : AnyView(Color("ContentBackgroundColor"))
    }
}

// struct LatestTopicsView_Previews: PreviewProvider {
//    static var previews: some View {
//        TopicsView(showError: Binding.constant(false))
//            .preferredColorScheme(.dark)
//    }
// }
