//
//  BadgeDemo.swift
//  Exercises
//
//  Created by Jaydeep Joshi on 03/05/22.
//

import SwiftUI

struct BadgeModifier: ViewModifier {
    var count: Int
    var position: Alignment = .topTrailing

    func body(content: Content) -> some View {
        let _ = print(count)
        if count != 0 {
            content.overlay(alignment: position) {
                Circle().fill(Color.red)
                    .overlay(
                        Text("\(count)")
                            .font(.footnote)
                            .foregroundColor(Color.white)
                    )
                    .frame(width: 24, height: 24)
                    .offset(x: position == .topTrailing ? 12 : -12, y: -12)
            }
        } else {
            content
        }
    }
}

extension View {
    func badge(count: Int, position: Alignment = .topTrailing) -> some View {
        self.modifier(BadgeModifier(count: count, position: position))
    }
}

struct BadgeDemo: View {
    @State var badgeCount: Double = 0
    @State var badgePosition: Alignment = .topTrailing

    var body: some View {
        VStack {
            Text("Hello, world!")
                .padding()
                .border(Color.black)
                .badge(count: Int(badgeCount), position: badgePosition)
            Slider(value: $badgeCount, in: -10...10, step: 1) {
                Text("Badge Count")
            } minimumValueLabel: {
                Text("-10")
            } maximumValueLabel: {
                Text("10")
            }
            HStack {
                Button("Top Leading") {
                    badgePosition = .topLeading
                }
                Button("Top Trailing") {
                    badgePosition = .topTrailing
                }
            }
        }
    }
}

struct BadgeDemo_Previews: PreviewProvider {
    static var previews: some View {
        BadgeDemo()
    }
}
