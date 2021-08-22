//
//  TicketsSearchView.swift
//  tog
//
//  Created by Artem Zhukov on 15.08.21.
//

import SwiftUI

struct TicketsSearchView: View {

  @ObservedObject var journeyQuery = JourneyQuery()

  init(origin: Stop, destination: Stop) {
    self.journeyQuery.query = .init(
      origin: origin,
      destination: destination,
      date: Date(),
      dateMode: .departure,
      passengers: 1
    )
  }

  var body: some View {
    List {
      Section {
        Text(journeyQuery.query.origin.name)
        Text(journeyQuery.query.destination.name)
      }
      Section(footer: Text("Press and hold to choose between departure and arrival")) {
        HStack {
          // Separate text and date picker because the padding doesn't look nice
          Text(journeyQuery.query.dateMode == .departure ? "Departure" : "Arrival")
          DatePicker("", selection: $journeyQuery.query.date)
            .offset(x: 10)
        }
        .contextMenu {
          Button(action: { journeyQuery.query.dateMode = .departure }, label: {
            Text("Departure")
          })
          Button(action: { journeyQuery.query.dateMode = .arrival }, label: {
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
      Section(header: Text("Search Results")) {
        if !journeyQuery.results.isEmpty {
          ForEach(journeyQuery.results, id: \.self) { journey in
            JourneyCell(journey: journey)
          }
        } else {
          Text("No results")
            .foregroundColor(Color.primary.opacity(0.3))
        }
      }
    }
    .listStyle(InsetGroupedListStyle())
    .navigationTitle("Select Journey")
    .navigationBarTitleDisplayMode(.inline)
    .navigationBarItems(trailing:
      Button(action: {
        journeyQuery.query = .init(
          origin: journeyQuery.query.destination,
          destination: journeyQuery.query.origin,
          date: journeyQuery.query.date,
          dateMode: journeyQuery.query.dateMode,
          passengers: journeyQuery.query.passengers
        )
      }, label: {
        Globals.Icons.swap
      })
    )
  }

}

struct TicketsSearchView_Previews: PreviewProvider {

  private static var results: [Stop] = [
    Stop(id: 8100450, name: "Wien Penzing Bahnhof", latitude: 0.5, longitude: 0.5),
    Stop(id: 8101947, name: "Wien Handelskai (Bahnsteige 11-12)", latitude: 0.5, longitude: 0.5)
  ]

  static var previews: some View {
    NavigationView {
      TicketsSearchView(origin: results[0], destination: results[1])
        .navigationTitle("Select Journey")
    }
  }

}
