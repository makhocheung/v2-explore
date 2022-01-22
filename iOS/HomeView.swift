//
//  HomeView.swift
//  V2EX You
//
//  Created by Mak Ho-Cheung on 2021/11/23.
//

import SwiftUI

struct HomeView: View {
    @State var tabSelection = 0
    let data = ["最新", "最热"]
    var body: some View {
        VStack {
//            ScrollableTabView(activeIdx: $tabSelection, dataSet: data)
//                .padding(.top, 10)
//                .foregroundColor(.accentColor)
            HStack {
                ForEach(0 ..< data.count, id: \.self) { index in
                    if tabSelection == index {
                        Text(data[index])
                            .padding(4)
                            .background(Color("StressBackgroundColor"))
                            .foregroundColor(Color("StressTextColor"))
                            .cornerRadius(5)

                    } else {
                        Text(data[index])
                            .padding(4)
                            .foregroundColor(Color.accentColor)
                            .onTapGesture {
                                tabSelection = index
                            }
                    }
                }
                Spacer()
            }
            .padding(.top, 5)
            .padding(.horizontal, 10)
            ZStack {
                if tabSelection == 0 {
                    LatestTopicsView()
                } else {
                    HotTopicsView()
                }
            }
        }
        .background(Color("RootBackgroundColor"))
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
