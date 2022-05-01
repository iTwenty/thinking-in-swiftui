//
//  KnobColorDemo.swift
//  Exercises
//
//  Created by Jaydeep Joshi on 03/05/22.
//

import SwiftUI

struct KnobShape: Shape {
    var pointerSize: CGFloat = 0.1 // these are relative values
    var pointerWidth: CGFloat = 0.1
    func path(in rect: CGRect) -> Path {
        let pointerHeight = rect.height * pointerSize
        let pointerWidth = rect.width * self.pointerWidth
        let circleRect = rect.insetBy(dx: pointerHeight, dy: pointerHeight)
        return Path { p in
            p.addEllipse(in: circleRect)
            p.addRect(CGRect(x: rect.midX - pointerWidth/2, y: 0, width: pointerWidth, height: pointerHeight + 2))
        }
    }
}

fileprivate struct PointerSizeKey: EnvironmentKey {
    static let defaultValue: CGFloat = 0.1
}

fileprivate struct KnobColorKey: EnvironmentKey {
    static let defaultValue: Color? = nil
}

extension EnvironmentValues {
    var knobPointerSize: CGFloat {
        get { self[PointerSizeKey.self] }
        set { self[PointerSizeKey.self] = newValue }
    }

    var knobColor: Color? {
        get { self[KnobColorKey.self] }
        set { self[KnobColorKey.self] = newValue }
    }
}

extension View {
    func knobPointerSize(_ size: CGFloat) -> some View {
        self.environment(\.knobPointerSize, size)
    }

    func knobColor(_ color: Color?) -> some View {
        self.environment(\.knobColor, color)
    }
}

struct Knob: View {
    @Binding var value: Double // should be between 0 and 1
    var pointerSize: CGFloat? = nil
    @Environment(\.knobPointerSize) var envPointerSize
    @Environment(\.knobColor) var color
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        KnobShape(pointerSize: pointerSize ?? envPointerSize)
            .fill(knobColor)
            .rotationEffect(Angle(degrees: value * 330))
            .onTapGesture {
                withAnimation(.default) {
                    self.value = self.value < 0.5 ? 1 : 0
                }
            }
    }

    private var knobColor: Color {
        if let c = color {
            return c
        }
        return colorScheme == .dark ? .white : .black
    }
}

struct KnobColorDemo: View {
    @State var value: Double = 0.5
    @State var knobSize: CGFloat = 0.1
    @State var knobColor: Color? = nil

    var body: some View {
        VStack {
            Knob(value: $value)
                .frame(width: 100, height: 100)
                .knobPointerSize(knobSize)
            HStack {
                Text("Value")
                Slider(value: $value, in: 0...1)
            }
            HStack {
                Text("Size")
                Slider(value: $knobSize, in: 0...0.4)
            }
            Button("Toggle") {
                withAnimation(.default) {
                    value = value == 0 ? 1 : 0
                }
            }
            Spacer().frame(height: 20)
            Text("Knob Color")
            HStack {
                Color.clear.overlay {
                    Text("none")
                }.onTapGesture {
                    knobColor = nil
                }
                Color.red.onTapGesture {
                    knobColor = .red
                }
                Color.green.onTapGesture {
                    knobColor = .green
                }
                Color.blue.onTapGesture {
                    knobColor = .blue
                }
            }.frame(height: 50)
        }.knobColor(knobColor)
    }
}

struct KnobColorDemo_Previews: PreviewProvider {
    static var previews: some View {
        KnobColorDemo()
    }
}
