//
//  CollapsibleHStackDemo.swift
//  Exercises
//
//  Created by Jaydeep Joshi on 03/05/22.
//

import SwiftUI

struct Collapsible<Element, Content: View>: View {
    var data: [Element]
    var expanded: Bool = false
    @ViewBuilder var content: (Element) -> Content

    @ViewBuilder private func child(at index: Int) -> some View {
        let childExpanded = expanded || index == data.endIndex - 1
        self.content(data[index])
            .frame(width: childExpanded ? nil : 10)
    }

    var body: some View {
        HStack(spacing: expanded ? nil : 0) {
            ForEach(0..<data.endIndex, id: \.self) { index in
                child(at: index)
            }
        }
    }
}

struct CollapsibleHStackDemo: View {
    @State var expanded = false
    let data = [Color.red, Color.green, Color.blue, Color.black]

    var body: some View {
        VStack(spacing: 0) {
            Collapsible(data: data, expanded: expanded) { $0 }
            Button {
                withAnimation {
                    expanded.toggle()
                }
            } label: {
                Text("Toggle").padding()
            }
        }
    }
}

struct CollapsibleHStackDemo_Previews: PreviewProvider {
    static var previews: some View {
        CollapsibleHStackDemo()
    }
}
