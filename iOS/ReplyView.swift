//
//  ReplyView.swift
//  V2EX You
//
//  Created by Mak Ho-Cheung on 2021/12/10.
//

import Kingfisher
import SwiftUI

struct ReplyView: View {
    var reply = testReplies[0]
    var isOP = false
    var floor = 1
    var body: some View {
        HStack(alignment: .top) {
            KFImage(URL(string: reply.member.avatarNormal))
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .cornerRadius(4)
            VStack {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(reply.member.username)
                                .bold()
                                .foregroundColor(.accentColor)
                            if isOP {
                                Text("OP")
                                    .padding(2)
                                    .foregroundColor(.blue)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 4)
                                            .stroke(Color.blue, lineWidth: 1)
                                    }
                            }
                        }
                        Text(timestamp2Date(timestamp: reply.lastModified))
                            .foregroundColor(.accentColor)
                        Text(reply.content)
                            .fixedSize(horizontal: false, vertical: true)
                            .font(.body)
                    }
                    Spacer()
                    Text("#\(floor)")
                        .foregroundColor(.accentColor)
                }
                Divider()
            }
        }
        .padding(EdgeInsets(top: 5, leading: 10, bottom: 0, trailing: 10))
        .font(.caption)
    }
}

struct ReplyView_Previews: PreviewProvider {
    static var previews: some View {
        ReplyView(isOP: true)
    }
}
