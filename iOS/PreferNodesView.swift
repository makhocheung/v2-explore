//
//  PreferNodesView.swift
//  V2EX You (iOS)
//
//  Created by Mak Ho-Cheung on 2022/2/13.
//

import SwiftUI

struct PreferNodesView: View {
    @StateObject var preferNodesState = PreferNodesState.shared
    @State var isShowAlert = false
    var body: some View {
        List {
            ForEach(preferNodesState.preferNodes) { it in
                HStack {
                    Text(it.title)
                        .padding(5)
                        .cornerRadius(10)
                    Spacer()
                    Button {
                        preferNodesState.addToDelete(index: preferNodesState.preferNodes.firstIndex(of: it)!)
                        isShowAlert.toggle()
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .confirmationDialog("确定要删除该节点吗", isPresented: $isShowAlert, titleVisibility: .visible) {
            Button(role: .destructive) {
                preferNodesState.batchDelete()
            } label: {
                Text("确认")
            }
            Button(role: .cancel) {
            } label: {
                Text("取消")
            }
        }
        .onAppear {
            preferNodesState.refresh()
        }
        .navigationTitle("节点管理")
    }
}

struct PreferNodesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PreferNodesView()
        }
    }
}
