//
//  ExercisesApp.swift
//  Exercises
//
//  Created by Jaydeep Joshi on 03/05/22.
//

import SwiftUI

var demos = ["02 - ImageLoader",
             "03 - KnobColor",
             "04 - Collapsible HStack",
             "04 - Badge"]

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
        case "02 - ImageLoader": ImageLoaderDemo()
        case "03 - KnobColor": KnobColorDemo()
        case "04 - Collapsible HStack": CollapsibleHStackDemo()
        case "04 - Badge": BadgeDemo()
        default: Text("No demo found!")
        }
    }
}
