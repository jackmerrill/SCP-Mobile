//
//  SeriesView.swift
//  SCP Mobile
//
//  Created by Jack Merrill on 6/12/21.
//

import SwiftUI
import SwiftSoup

let numTranslate = [
    "I": "",
    "II": "-2",
    "III": "-3",
    "IV": "-4",
    "V": "-5",
    "VI": "-6"
]

let seriesLimit = [
    "1": "900 to 999",
    "2": "1900 to 1999",
    "3": "2900 to 2999",
    "4": "3900 to 3999",
    "5": "4900 to 4999",
    "6": "5900 to 5999"
]

class SeriesGroupViewModel: ObservableObject {
    @Published var groupResults: [String] = []

    func getGroups(series: String) {
        do {
            let seriesNumber: String? = numTranslate[series]
            print(seriesNumber!)
            let url = URL(string: "https://scp-wiki.wikidot.com/scp-series" + seriesNumber!)
            let html = try String(contentsOf: url!, encoding: String.Encoding.ascii)
            let doc: Document = try SwiftSoup.parse(html)
            let series: Elements = try doc.select("html body#html-body div#skrollr-body div#container-wrap-wrap div#container-wrap div#container div#content-wrap div#main-content div#page-content div.content-panel.standalone.series ul")
            self.groupResults.removeAll()
            try series.dropFirst().dropLast().dropLast().forEach { scps in
                try scps.children().forEach { scp in
                    self.groupResults.append(try scp.text())
                }
            }
        } catch Exception.Error(type: let type, Message: let message) {
            print(type)
            print(message)
        } catch {
            print("")
        }
    }
}

struct SeriesView: View {
    @ObservedObject var VModel: SeriesGroupViewModel
    @ObservedObject var SCPVModel: SCPViewModel
    
    var series: String
        
    var body: some View {
        VStack {
            List {
                ForEach(VModel.groupResults, id: \.self) { scp in
                    NavigationLink(destination: SCPView(VModel: SCPVModel, scp: scp)) {
                        VStack {
                            Text(scp)
                        }
                    }
                }
            }
        }
        .navigationTitle(Text("Series " + series))
        .onAppear(perform: {
            VModel.getGroups(series: series)
        })
    }
}

//struct SeriesView_Previews: PreviewProvider {
//    static var previews: some View {
//        SeriesView(series: "I")
//    }
//}
