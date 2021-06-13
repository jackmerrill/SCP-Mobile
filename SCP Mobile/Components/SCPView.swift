//
//  SCPView.swift
//  SCP Mobile
//
//  Created by Jack Merrill on 6/12/21.
//

import SwiftUI
import SwiftSoup
import SwiftyJSON

struct SCPData {
    var item: String?
    var obj_class: String?
    var containment: String?
    var description: String?
    var image: String?
}

class SCPViewModel: ObservableObject {
    @Published var data = SCPData()
    
    func getSCPData(scp: String) {
        do {
            let scpNumber = scp.components(separatedBy: "-")[1].trimmingCharacters(in: .whitespacesAndNewlines).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)
            print("https://scpscraper.jackmerrill.repl.co/api/scp/" + scpNumber!)
            let url = URL(string: "https://scpscraper.jackmerrill.repl.co/api/scp/" + scpNumber!)
            let apiData = try String(contentsOf: url!, encoding: String.Encoding.ascii)

            if let jsonData = apiData.data(using: .utf8) {
                if let json = try? JSON(data: jsonData) {
                    let content = json["content"]
                    let image = json["image"]
                    data.obj_class = content["Object Class"].rawString()
                    data.description = content["Description"].rawString()
                    data.containment = content["Special Containment Procedures"].rawString()
                    if image["src"].exists() {
                        data.image = image["src"].rawString()
                    }
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

struct SCPView: View {
    @ObservedObject var VModel: SCPViewModel
    
    var scp: String
    
    var body: some View {
        ScrollView {
            VStack {
                Section() {
                        Text("Object Class").fontWeight(.bold)
                    Text(VModel.data.obj_class ?? "Error").fontWeight(.regular)            .padding(.bottom)

                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Section() {
                    Text("Special Containment Procedures").fontWeight(.bold)
                    Text(VModel.data.containment ?? "Error")
                        .fontWeight(.regular)
                        .padding(.bottom)
                        .lineLimit(nil)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Section() {
                    Text("Description").fontWeight(.bold)
                    Text(VModel.data.description ?? "Error")
                        .fontWeight(.regular)
                        .padding(.bottom)
                        .lineLimit(nil)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
            }.frame(maxWidth: .infinity)
        }
        .padding(20)
        .navigationTitle(Text(scp.components(separatedBy: " - ")[0]))
        .onAppear(perform: {
            VModel.getSCPData(scp: scp)
        })
    }
}

struct SCPView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Section() {
                    Text("Object Class").fontWeight(.bold)
                    Text("Keter").fontWeight(.regular)            .padding(.bottom)

            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Section() {
                    Text("Special Containment Procedures").fontWeight(.bold)
                    Text("Bruhhhhhh").fontWeight(.regular)            .padding(.bottom)

            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Section() {
                    Text("Description").fontWeight(.bold)
                    Text("Bruhhhhhh").fontWeight(.regular)            .padding(.bottom)

            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
        }
        .padding(40)
        .navigationTitle(Text("SCP-004"))

    }
}
