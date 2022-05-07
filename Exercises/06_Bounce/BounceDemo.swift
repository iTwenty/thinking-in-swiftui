//
//  BounceDemo.swift
//  Exercises
//
//  Created by Jaydeep Joshi on 07/05/22.
//

import SwiftUI

struct Bounce: AnimatableModifier {
    var times: CGFloat = 0
    var amplitude: CGFloat = 10
    var elasticity: CGFloat = 0
    var animatableData: CGFloat {
        get { times }
        set { times = newValue }
    }

    // Things don't work as expected with elasticity > 1.
    // Need to find better math function to approximate bounce.
    // Current function : https://www.desmos.com/calculator/lhmd9vshsd
    func body(content: Content) -> some View {
        if elasticity < 1 {
            return content.offset(y: -abs(sin(times * .pi)) * amplitude)
        } else {
            let quotient = times * elasticity * .pi
            let remainder = quotient == 0 ? 1 : quotient
            return content.offset(y: -abs(sin(quotient) / remainder) * amplitude)
        }
    }
}

extension View {
    func bounce(times: Int, amplitude: Int = 10, elasticity: Int = 0) -> some View {
        return modifier(Bounce(times: CGFloat(times),
                               amplitude: CGFloat(amplitude),
                               elasticity: CGFloat(elasticity)))
    }
}

struct BounceDemo: View {
    @State private var taps: Int = 0

    var body: some View {
        Button(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/) {
            withAnimation(.linear(duration: 2)) {
                self.taps += 1
            }
        }.bounce(times: taps, amplitude: 50, elasticity: 3)
    }
}

struct BounceDemo_Previews: PreviewProvider {
    static var previews: some View {
        BounceDemo()
    }
}
