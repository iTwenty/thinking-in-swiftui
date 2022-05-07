//
//  ExercisesApp.swift
//  Exercises
//
//  Created by Jaydeep Joshi on 03/05/22.
//

import SwiftUI

var demos = ["00 - Testing",
             "02 - ImageLoader",
             "03 - KnobColor",
             "04 - Collapsible HStack",
             "04 - Badge",
             "05 - Table View"]

@main
struct ExercisesApp: App {
    @State var selectedDemo: String? = nil

    var body: some Scene {
        WindowGroup {
            NavigationView {
                List(demos, id: \.self) { demo in
                    NavigationLink(demo) {
                        viewForDemo(demo)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func viewForDemo(_ demo: String) -> some View {
        switch demo {
        case demos[0]: TestingDemo()
        case demos[1]: ImageLoaderDemo()
        case demos[2]: KnobColorDemo()
        case demos[3]: CollapsibleHStackDemo()
        case demos[4]: BadgeDemo()
        case demos[5]: TableViewDemo()
        default: Text("No demo found!")
        }
    }
}
