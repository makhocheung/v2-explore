//
//  SwiftUIView.swift
//  V2EX You (iOS)
//
//  Created by Mak Ho-Cheung on 2021/12/11.
//

import SwiftUI

struct ProfileView: View {
    @State var isShowCleanCacheAlert = false
    init() {
        UITableViewCell.appearance().backgroundColor = UIColor(Color("RootBackgroundColor"))
        UITableView.appearance().backgroundColor = UIColor(Color("RootBackgroundColor"))
    }

    var body: some View {
        VStack {
            Image("Icon")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            Text("V2EX You")
                .font(.title)
            Text("v1.0(build 1)")
                .foregroundColor(.gray)
                .padding(.bottom)
            VStack(spacing: 15) {
                NavigationLink {
                    PreferNodesView()
                } label: {
                    Label("节点管理", systemImage: "circle.dashed.inset.filled")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Divider()
                Button {
                    isShowCleanCacheAlert.toggle()
                } label: {
                    Label("缓存清理", systemImage: "clear.fill")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .confirmationDialog("确定要清理缓存吗", isPresented: $isShowCleanCacheAlert, titleVisibility: .visible) {
                    Button(role: .destructive) {
                    } label: {
                        Text("确认")
                    }
                    Button(role: .cancel) {
                    } label: {
                        Text("取消")
                    }
                }
                Divider()
                Button {
                } label: {
                    Label("GitHub 与反馈", systemImage: "link.circle.fill")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Divider()
                Button {
                } label: {
                    Label("分享", systemImage: "square.and.arrow.up.fill")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(.horizontal, 30)
            Spacer()
            Text("Develop by Mak Ho Cheung")
                .font(.footnote)
                .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color("RootBackgroundColor"))
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileView()
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
