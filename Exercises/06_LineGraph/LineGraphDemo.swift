//
//  LineGraphDemo.swift
//  Exercises
//
//  Created by Jaydeep Joshi on 07/05/22.
//

import SwiftUI

struct PositionOnShapeEffect: GeometryEffect {
    var path: Path
    var fraction: CGFloat

    var animatableData: CGFloat {
        get { fraction }
        set { fraction = newValue }
    }

    func effectValue(size: CGSize) -> ProjectionTransform {
        let currentPoint = path.trimmedPath(from: 0, to: fraction).currentPoint ?? .zero
        let translation = CGAffineTransform(translationX: currentPoint.x - size.width / 2, y: currentPoint.y - size.height / 2)
        return ProjectionTransform(translation)
    }
}

extension View {
    func position<S: Shape>(on shape: S, at fraction: CGFloat) -> some View {
        GeometryReader { proxy in
            self.modifier(PositionOnShapeEffect(path: shape.path(in: CGRect(origin: .zero, size: proxy.size)), fraction: fraction))
        }
    }
}

struct LineGraph: Shape {
    var points: [CGFloat]
    private var animatablePoints: AnimatableVector

    init(points: [CGFloat]) {
        self.points = points
        self.animatablePoints = AnimatableVector(with: points)
    }

    var animatableData: AnimatableVector {
        get { animatablePoints }
        set { animatablePoints = newValue }
    }

    func path(in rect: CGRect) -> Path {
        let xDistance = rect.width / CGFloat(points.count - 1)
        var path = Path()
        for index in points.indices {
            let pathPoint = pathPoint(index: index, xDistance: xDistance, rect: rect)
            if index == 0 {
                path.move(to: pathPoint)
            } else {
                path.addLine(to: pathPoint)
            }
        }
        return path
    }

    private func pathPoint(index: Int, xDistance: CGFloat, rect: CGRect) -> CGPoint {
        let x = CGFloat(index) * xDistance
        let y = (1 - animatablePoints.values[index]) * rect.height
        return CGPoint(x: x, y: y)
    }
}

struct LineGraphDemo: View {
    @State var sampleData: [CGFloat] = [0.1, 0.7, 0.3, 0.6, 0.45, 1.1]
    @State var fraction = CGFloat.zero
    @State var showLeadingDot = false

    var body: some View {
        if sampleData.count < 2 {
            Text("Must have atleast two points to plot a graph! 🤷‍♂️")
        } else {
            VStack {
                ZStack {
                    LineGraph(points: sampleData)
                        .trim(from: 0, to: fraction)
                        .stroke(Color.red, lineWidth: 1)
                        .border(Color.gray, width: 1)
                        .onAppear {
                            retrace()
                        }
                    if showLeadingDot {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 10, height: 10)
                            .position(on: LineGraph(points: sampleData), at: fraction)
                    }
                }.frame(width: 200, height: 100)
                Text(sampleData.map { String(format: "%.2f", $0) }.joined(separator: "     "))
                    .font(.caption2)
                Button("Retrace") {
                    retrace()
                }
                Button("Randomize data") {
                    regen()
                }
                Toggle("Show Leading Dot", isOn: $showLeadingDot)
            }
        }
    }

    private func retrace() {
        let animation = Animation.linear(duration: 2)
        fraction = 0
        withAnimation(animation) {
            fraction = 1
        }
    }

    private func regen() {
        var newData = [CGFloat]()
        for _ in sampleData {
            let value = CGFloat.random(in: 0.0...1.1)
            newData.append(value)
        }
        withAnimation {
            sampleData = newData
        }
    }
}

struct LineGraphDemo_Previews: PreviewProvider {
    static var previews: some View {
        LineGraphDemo()
    }
}
