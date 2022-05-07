//
//  TableViewDemo.swift
//  Exercises
//
//  Created by Jaydeep Joshi on 04/05/22.
//

import SwiftUI

struct MaxWidthColumnKey: PreferenceKey {
    static var defaultValue: [Int: CGFloat] = [:]

    static func reduce(value: inout [Int: CGFloat], nextValue: () -> [Int: CGFloat]) {
        value = value.merging(nextValue(), uniquingKeysWith: max)
    }
}

extension View {
    func setMaxWidthColumnPreference(column: Int) -> some View {
        self.background {
            GeometryReader { proxy in
                Color.clear.preference(key: MaxWidthColumnKey.self, value: [column: proxy.size.width])
            }
        }
    }
}

struct TableViewCell<Cell: View>: View {
    var cell: Cell
    let columnIndex: Int
    let width: CGFloat?
    let selected: Bool

    var body: some View {
        cell.setMaxWidthColumnPreference(column: columnIndex)
            .frame(width: width, alignment: .topLeading)
            .padding()
            .border(Color.blue.opacity(selected ? 1 : 0))
    }
}

struct TableView<Cell: View>: View {
    var cells: [[Cell]]
    @State var maxColumnWidths: [Int: CGFloat]
    @State var selectedCell: (Int, Int)?

    init(cells: [[Cell]]) {
        self.cells = cells
        self.maxColumnWidths = [:]
        selectedCell = nil
    }

    var body: some View {
        let rows = cells.count
        let columns = cells[0].count
        VStack(alignment: .leading) {
            ForEach(0..<rows, id: \.self) { rowIndex in
                HStack(alignment: .top) {
                    ForEach(0..<columns, id: \.self) { colIndex in
                        let selected = selectedCell?.0 == rowIndex && selectedCell?.1 == colIndex
                        TableViewCell(cell: cells[rowIndex][colIndex],
                                      columnIndex: colIndex,
                                      width: maxColumnWidths[colIndex],
                                      selected: selected)
                            .onTapGesture {
                                selectedCell = (rowIndex, colIndex)
                            }
                    }
                }.background(rowIndex.isMultiple(of: 2) ? Color.white : Color.gray)
            }
        }.onPreferenceChange(MaxWidthColumnKey.self) { widths in
            maxColumnWidths = widths
        }
    }
}

struct TableViewDemo: View {
    var cells = [
        [Text("").bold(), Text("Monday").bold(), Text("Tuesday").bold(), Text("Wednesday").bold()],
        [Text("Berlin").bold(), Text("Cloudy"), Text("Mostly\nSunny"), Text("Sunny")],
        [Text("London").bold(), Text("Heavy Rain"), Text("Cloudy"), Text( "Sunny")],
    ]

    var body: some View {
        ScrollView([.horizontal, .vertical]) {
            TableView(cells: cells)
                .font(Font.system(.body, design: .serif))
        }
    }
}

struct TableViewDemo_Previews: PreviewProvider {
    static var previews: some View {
        TableViewDemo()
    }
}
