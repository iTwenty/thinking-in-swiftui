//
//  TestingDemo.swift
//  Exercises
//
//  Created by Jaydeep Joshi on 07/05/22.
//

import SwiftUI

struct WidthKey: PreferenceKey {
    static let defaultValue: CGFloat? = nil
    static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) {
        value = value ?? nextValue()
    }
}

struct TextWithCircle: View {
    @State private var width: CGFloat? = nil
    var body: some View {
        Text("Hello, world")
            .background(GeometryReader { proxy in
                Color.clear.preference(key: WidthKey.self, value: proxy.size.width)
            })
            .onPreferenceChange(WidthKey.self) { self.width = $0 }
            .frame(width: width, height: width)
            .background(Circle().fill(Color.blue))
    }
}

struct TestingDemo: View {
    var body: some View {
        TextWithCircle()
    }
}

struct TestingDemo_Previews: PreviewProvider {
    static var previews: some View {
        TestingDemo()
    }
}
