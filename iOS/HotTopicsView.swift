//
//  HotTopicsView.swift
//  V2EX You (iOS)
//
//  Created by Mak Ho-Cheung on 2021/12/11.
//

import SwiftUI

struct HotTopicsView: View {
    @State var topics: [Topic] = []
    @State var showError = false
    var body: some View {
        RefreshableScrollView(onRefresh: { done in
            Task {
                
            }
        }) {
            VStack {
                ForEach(0 ..< topics.count, id: \.self) { index in
                    if index == 0 {
                        Divider()
                    }
                    NavigationLinkView(topic: topics[index])
                    Divider()
                }
            }
        }
        .background(bgView)
        .alert("获取或解析数据出错", isPresented: $showError) {
            Text("完成")
        }
        .task {
            do {
                let url = URL(string: "https://www.v2ex.com/api/topics/hot.json?time=\(Date().timeIntervalSince1970)")!
                let (data, _) = try await URLSession.shared.data(from: url)
                topics = try JSONDecoder().decode([Topic].self, from: data)
            } catch {
                print("\(error)")
                showError.toggle()
            }
        }
    }

    var bgView: some View {
        topics.isEmpty ? AnyView(ProgressView()) : AnyView(Color("ContentBackgroundColor"))
    }
}

struct HotTopicsView_Previews: PreviewProvider {
    static var previews: some View {
        HotTopicsView()
    }
}
