//
//  SeriesListView.swift
//  SCP Mobile
//
//  Created by Jack Merrill on 6/12/21.
//

import SwiftUI
import SwiftSoup

class SeriesViewModel: ObservableObject {
    @Published var seriesResults: [String] = []
    
    func getSeries() {
        do {
            let url = URL(string: "https://scp-wiki.wikidot.com/")
            let html = try String(contentsOf: url!, encoding: String.Encoding.ascii)
            let doc: Document = try SwiftSoup.parse(html)
            let series: Element = try doc.select("div.menu-item")[1]
            self.seriesResults.removeAll()
            try series.children().dropFirst().dropFirst().base.forEach { element in
                if (!element.hasText()) { return }
                self.seriesResults.append(try element.text())
            }
            
        } catch Exception.Error(type: let type, Message: let message) {
            print(type)
            print(message)
        } catch {
            print("")
        }
    }
}

struct SeriesListView: View {
    @ObservedObject var SeriesVModel: SeriesViewModel
    @ObservedObject var SeriesGroupVModel: SeriesGroupViewModel
    @ObservedObject var SCPVModel: SCPViewModel
    
    var body: some View {
            List {
                ForEach(SeriesVModel.seriesResults, id: \.self) { result in
                    NavigationLink(destination: SeriesView(VModel: SeriesGroupVModel, SCPVModel: SCPVModel, series: result)) {
                        Text("Series " + result)
                    }
                }
            }
            .navigationBarTitle("SCP Database")
            .navigationBarTitleDisplayMode(.large)
            .onAppear(perform: {
                SeriesVModel.getSeries()
            })
    }
}
//
//struct SeriesListView_Previews: PreviewProvider {
//    @ObservedObject var VModel = ViewModel()
//    static var previews: some View {
//        SeriesListView(VModel: VModel)
//    }
//}
