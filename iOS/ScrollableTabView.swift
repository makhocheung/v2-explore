//
//  TestUI.swift
//  V2EX You
//
//  Created by Mak Ho-Cheung on 2021/12/8.
//

import SwiftUI

struct ScrollableTabView: View {
    @Binding var activeIdx: Int
    @State private var w: [CGFloat]
    private let dataSet: [String]
    init(activeIdx: Binding<Int>, dataSet: [String]) {
        _activeIdx = activeIdx
        self.dataSet = dataSet
        _w = State(initialValue: [CGFloat](repeating: 0, count: dataSet.count))
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { scrollReader in
                VStack(alignment: .underlineLeading, spacing: 5) {
                    HStack {
                        ForEach(0 ..< dataSet.count) { i in
                            Text(dataSet[i])
                                .font(Font.body)
                                .modifier(ScrollableTabViewModifier(activeIdx: $activeIdx, idx: i))
                                .background(TextGeometry())
                                .onPreferenceChange(WidthPreferenceKey.self, perform: { self.w[i] = $0 })
                                .id(i)
                            Spacer().frame(width: 20)
                        }
                    }
                    .padding(.horizontal, 10)
                    Rectangle()
                        .alignmentGuide(.underlineLeading) { d in d[.leading] }
                        .frame(width: w[activeIdx], height: 3)
                        .cornerRadius(5)
                        .animation(.linear)
                }
                .onChange(of: activeIdx, perform: { value in
                    withAnimation {
                        scrollReader.scrollTo(value, anchor: .center)
                    }
                })
            }
        }
    }
}

extension HorizontalAlignment {
    private enum UnderlineLeading: AlignmentID {
        static func defaultValue(in d: ViewDimensions) -> CGFloat {
            return d[.leading]
        }
    }

    static let underlineLeading = HorizontalAlignment(UnderlineLeading.self)
}

struct WidthPreferenceKey: PreferenceKey {
    static var defaultValue = CGFloat(0)

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }

    typealias Value = CGFloat
}

struct TextGeometry: View {
    var body: some View {
        GeometryReader { geometry in
            Rectangle().fill(Color.clear).preference(key: WidthPreferenceKey.self, value: geometry.size.width)
        }
    }
}

struct ScrollableTabViewModifier: ViewModifier {
    @Binding var activeIdx: Int
    let idx: Int

    func body(content: Content) -> some View {
        Group {
            if activeIdx == idx {
                content.alignmentGuide(.underlineLeading) { d in
                    d[.leading]
                }.onTapGesture {
                    withAnimation {
                        self.activeIdx = self.idx
                    }
                }

            } else {
                content.onTapGesture {
                    withAnimation {
                        self.activeIdx = self.idx
                    }
                }
            }
        }
    }
}
