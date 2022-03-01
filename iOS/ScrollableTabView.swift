////
////  TestUI.swift
////  V2EX You
////
////  Created by Mak Ho-Cheung on 2021/12/8.
////
//
//import SwiftUI
//
//struct ScrollableTabView: View {
//    @StateObject var preferNodesState: PreferNodesState
//    @Binding var activeIdx: Int
//
//    init(activeIdx: Binding<Int>) {
//        _activeIdx = activeIdx
//        _preferNodesState = StateObject(wrappedValue: PreferNodesState.shared)
//    }
//
//    var body: some View {
//        ScrollView(.horizontal, showsIndicators: false) {
//            ScrollViewReader { scrollReader in
//                VStack(alignment: .underlineLeading, spacing: 5) {
//                    HStack {
//                        ForEach(0 ..< preferNodesState.preferNodes.count, id: \.self) { i in
//                            Text(preferNodesState.preferNodes[i].title)
//                                .font(Font.body)
//                                .modifier(ScrollableTabViewModifier(activeIdx: $activeIdx, idx: i))
//                                .background(TextGeometry())
//                                .onPreferenceChange(WidthPreferenceKey.self, perform: { preferNodesState.w[i] = $0 })
//                                .id(i)
//                            Spacer().frame(width: 20)
//                        }
//                    }
//                    .padding(.horizontal, 10)
//                    Rectangle()
//                        .alignmentGuide(.underlineLeading) { d in d[.leading] }
//                        .frame(width: preferNodesState.w[activeIdx], height: 3)
//                        .cornerRadius(5)
//                        .animation(.linear)
//                }
//                .onChange(of: activeIdx, perform: { value in
//                    withAnimation {
//                        scrollReader.scrollTo(value, anchor: .center)
//                    }
//                })
//            }
//        }
//    }
//}
//
//extension HorizontalAlignment {
//    private enum UnderlineLeading: AlignmentID {
//        static func defaultValue(in d: ViewDimensions) -> CGFloat {
//            return d[.leading]
//        }
//    }
//
//    static let underlineLeading = HorizontalAlignment(UnderlineLeading.self)
//}
//
//struct WidthPreferenceKey: PreferenceKey {
//    static var defaultValue = CGFloat(0)
//
//    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
//        value = nextValue()
//    }
//
//    typealias Value = CGFloat
//}
//
//struct TextGeometry: View {
//    var body: some View {
//        GeometryReader { geometry in
//            Rectangle().fill(Color.clear).preference(key: WidthPreferenceKey.self, value: geometry.size.width)
//        }
//    }
//}
//
//struct ScrollableTabViewModifier: ViewModifier {
//    @Binding var activeIdx: Int
//    let idx: Int
//
//    func body(content: Content) -> some View {
//        Group {
//            if activeIdx == idx {
//                content.alignmentGuide(.underlineLeading) { d in
//                    d[.leading]
//                }.onTapGesture {
//                    withAnimation {
//                        self.activeIdx = self.idx
//                    }
//                }
//
//            } else {
//                content.onTapGesture {
//                    withAnimation {
//                        self.activeIdx = self.idx
//                    }
//                }
//            }
//        }
//    }
//}
