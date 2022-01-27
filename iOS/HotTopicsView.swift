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
        ScrollView {
            VStack {
                ForEach(topics) { topic in
                    NavigationLink {
                        TopicView(topic: topic)
                    } label: {
                        BriefTopicView(briefTopic: topic)
                    }
                    Divider()
                }
            }
        }
        .background(Color("ContentBackgroundColor"))
        .alert("获取或解析数据出错", isPresented: $showError) {
            Text("完成")
        }
        .refreshable {
            do {
                let url = URL(string: "https://www.v2ex.com/api/topics/hot.json?time=\(Date().timeIntervalSince1970)")!
                let (data, _) = try await URLSession.shared.data(from: url)
                topics = try JSONDecoder().decode([Topic].self, from: data)
            } catch {
                print("\(error)")
                showError.toggle()
            }
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
}

struct HotTopicsView_Previews: PreviewProvider {
    static var previews: some View {
        HotTopicsView()
    }
}
