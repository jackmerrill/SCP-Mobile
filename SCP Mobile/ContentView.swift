//
//  ContentView.swift
//  SCP Mobile
//
//  Created by Jack Merrill on 6/12/21.
//

import SwiftUI
import SwiftSoup

struct ContentView: View {
    @ObservedObject var SeriesVModel = SeriesViewModel()
    @ObservedObject var SeriesGroupVModel = SeriesGroupViewModel()
    @ObservedObject var SCPVModel = SCPViewModel()
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                SeriesListView(SeriesVModel: SeriesVModel, SeriesGroupVModel: SeriesGroupVModel, SCPVModel: SCPVModel)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
