//
//  TicketsSearchView.swift
//  tog
//
//  Created by Artem Zhukov on 15.08.21.
//

import SwiftUI

struct TicketsSearchView: View {

  @State var origin: Stop
  @State var destination: Stop

  @State var date = Date()
  @State var selectingDeparture = true

  var body: some View {
    List {
      Section {
        Text(origin.name)
        Text(destination.name)
      }
      Section {
        HStack {
          // Separate text and date picker because the padding doesn't look nice
          Text(selectingDeparture ? "Departure" : "Arrival")
          DatePicker("", selection: $date)
            .offset(x: 10)
        }
        .contextMenu {
          Button(action: { selectingDeparture = true }, label: {
            Text("Departure")
          })
          Button(action: { selectingDeparture = false }, label: {
            Text("Arrival")
          })
        }
        HStack {
          Text("Passengers")
          Spacer()
          Text("Me")
            .opacity(0.3)
        }
      }
    }
    .listStyle(InsetGroupedListStyle())
    .navigationTitle("Select Journey")
    // .navigationBarTitleDisplayMode(.inline)
    .navigationBarItems(trailing:
      Button(action: {
        swap(&origin, &destination)
      }, label: {
        Globals.Icons.swap
      })
    )
  }

}

struct TicketsSearchView_Previews: PreviewProvider {

  @Autowired
  private static var dataService: DataService!
  private static var results = dataService.stops(by: "Wien")

  static var previews: some View {
    NavigationView {
      TicketsSearchView(origin: results[0], destination: results[1])
        .navigationTitle("Select Journey")
    }
  }

}
