//
//  ViewWithTallerHeightOfTwo.swift
//  RandomReminder
//
//  Created by Luca Napoli on 10/2/2026.
//

import SwiftUI


// Credit goes to the post below
// https://www.fivestars.blog/articles/swiftui-share-layout-information/
private struct SizePreferenceKey: PreferenceKey {
    static let defaultValue: CGSize = .zero

    static func reduce(value _: inout CGSize, nextValue _: () -> CGSize) {}
}

private extension View {
    func readSize(_ onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}

struct ViewWithTallerHeightOfTwo<First: View, Second: View>: View {
    let first: First
    let second: Second
    @Binding private var showFirst: Bool
    @State private var firstViewHeight: CGFloat = 0
    @State private var secondViewHeight: CGFloat = 0

    var body: some View {
        ZStack(alignment: .topLeading) {
            first
                .readSize { size in
                    firstViewHeight = size.height
                }
                .opacity(showFirst ? 1 : 0)
            second
                .readSize { size in
                    secondViewHeight = size.height
                }
                .opacity(showFirst ? 0 : 1)
        }
        .frame(height: height)
    }

    private var height: CGFloat? {
        if firstViewHeight == 0 || secondViewHeight == 0 {
            nil
        } else {
            max(firstViewHeight, secondViewHeight)
        }
    }

    init(_ first: First, _ second: Second, showFirst: Binding<Bool>) {
        self.first = first
        self.second = second
        self._showFirst = showFirst
    }
}

struct ViewWithTallerHeightOfTwo_Previews: PreviewProvider {
    struct Preview: View {
        @State private var showFirst = true

        var body: some View {
            VStack {
                Button("Toggle show first") {
                    showFirst.toggle()
                }
                .frame(width: 200)
                Text("First shown? \(showFirst)")

                Spacer().frame(height: 15)
                ViewWithTallerHeightOfTwo(
                    Button("Hello") {},
                    VStack(alignment: .leading) {
                        Text("Hello")
                        Text("World!")
                    },
                    showFirst: $showFirst
                )
                .border(.blue)
            }
            .padding()
        }
    }

    static var previews: some View {
        Preview()
    }
}
