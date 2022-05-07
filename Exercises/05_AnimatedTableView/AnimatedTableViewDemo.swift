//
//  AnimatedTableViewDemo.swift
//  Exercises
//
//  Created by Jaydeep Joshi on 07/05/22.
//

import SwiftUI

struct CellBoundsData: Equatable {
    let rowIndex: Int
    let colIndex: Int
    let bounds: Anchor<CGRect>
}

struct CellBoundsKey: PreferenceKey {
    static var defaultValue: [CellBoundsData] = []

    static func reduce(value: inout [CellBoundsData], nextValue: () -> [CellBoundsData]) {
        value.append(contentsOf: nextValue())
    }
}

struct AnimatedTableViewCell<Cell: View>: View {
    var cell: Cell
    let rowIndex: Int
    let colIndex: Int
    let width: CGFloat?

    var body: some View {
        cell.setMaxWidthColumnPreference(column: colIndex)
            .frame(width: width, alignment: .topLeading)
            .padding()
            .anchorPreference(key: CellBoundsKey.self, value: .bounds) { anchor in
                [CellBoundsData(rowIndex: rowIndex, colIndex: colIndex, bounds: anchor)]
            }
    }
}

struct AnimatedTableView<Cell: View>: View {
    var cells: [[Cell]]
    @State var maxColumnWidths: [Int: CGFloat]
    @State var selectedCell: (Int, Int)?

    init(cells: [[Cell]]) {
        self.cells = cells
        self.maxColumnWidths = [:]
    }

    var body: some View {
        let rows = cells.count
        let columns = cells[0].count
        VStack(alignment: .leading) {
            ForEach(0..<rows, id: \.self) { rowIndex in
                HStack(alignment: .top) {
                    ForEach(0..<columns, id: \.self) { colIndex in
                        AnimatedTableViewCell(cell: cells[rowIndex][colIndex],
                                              rowIndex: rowIndex,
                                              colIndex: colIndex,
                                              width: maxColumnWidths[colIndex])
                        .onTapGesture {
                            self.selectedCell = (rowIndex, colIndex)
                        }
                    }
                }.background(rowIndex.isMultiple(of: 2) ? Color.white : Color.gray)
            }
        }.onPreferenceChange(MaxWidthColumnKey.self) { widths in
            maxColumnWidths = widths
        }.overlayPreferenceValue(CellBoundsKey.self) { data in
            GeometryReader { proxy in
                createBorder(proxy, data)
            }
        }
    }

    @ViewBuilder
    private func createBorder(_ proxy: GeometryProxy, _ data: [CellBoundsData]) -> some View {
        let selectedData = data.first { d in
            selectedCell?.0 == d.rowIndex && selectedCell?.1 == d.colIndex
        }
        let selectedBounds = selectedData.map { proxy[$0.bounds] } ?? .zero
        RoundedRectangle(cornerRadius: 3)
            .stroke(lineWidth: 1.0)
            .foregroundColor(Color.blue)
            .frame(width: selectedBounds.size.width, height: selectedBounds.size.height)
            .offset(x: selectedBounds.minX, y: selectedBounds.minY)
            .animation(.default)
    }
}

struct AnimatedTableViewDemo: View {
    var cells = [
        [Text("").bold(), Text("Monday").bold(), Text("Tuesday").bold(), Text("Wednesday").bold()],
        [Text("Berlin").bold(), Text("Cloudy"), Text("Mostly\nSunny"), Text("Sunny")],
        [Text("London").bold(), Text("Heavy Rain"), Text("Cloudy"), Text( "Sunny")],
    ]

    var body: some View {
        ScrollView([.horizontal, .vertical]) {
            AnimatedTableView(cells: cells)
                .font(Font.system(.body, design: .serif))
        }
    }
}

struct AnimatedTableViewDemo_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedTableViewDemo()
    }
}
