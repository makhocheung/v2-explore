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
        VStack {
            HStack {
                KFImage(URL(string: reply.member.avatarNormal))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .cornerRadius(4)
                VStack(alignment: .leading) {
                    HStack {
                        Text(reply.member.username)
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
                        .foregroundColor(.secondary)
                }
                Spacer()
                Text("#\(floor)")
                    .foregroundColor(.secondary)
            }
            Text(reply.content)
                .fixedSize(horizontal: false, vertical: true)
                .font(.body)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .font(.caption)
    }
}

struct ReplyView_Previews: PreviewProvider {
    static var previews: some View {
        ReplyView(isOP: true)
    }
}
