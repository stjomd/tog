//
//  TicketsSearchView.swift
//  tog
//
//  Created by Artem Zhukov on 15.08.21.
//

import SwiftUI

// Wrapper to load contents lazily - otherwise the request is sent immediately
// as the stop is selected in the stations search.
struct TicketsSearchView: View {

  @State var isShowingAddToFavorites = false

  let origin: Stop
  let destination: Stop

  var body: some View {
    TicketsSearchViewContents(
      origin: origin,
      destination: destination,
      isShowingAddToFavorites: $isShowingAddToFavorites
    )
    .navigationTitle("Select Journey")
    .navigationBarTitleDisplayMode(.inline)
    .navigationBarBackButtonHidden(true)
  }

}

struct TicketsSearchViewContents: View {

  @Environment(\.presentationMode) private var presentationMode

  @Binding private var isShowingAddToFavorites: Bool
  @ObservedObject private var journeyQuery = JourneyQuery()

  @ObservedObject private var favorites = FavoritesQuery()
  private var existingFavorite: FavoriteDestination? {
    favorites.results.filter {
      $0.origin!.id == self.journeyQuery.query.origin.id &&
      $0.destination!.id == self.journeyQuery.query.destination.id
    }
    .first
  }

  init(origin: Stop, destination: Stop, isShowingAddToFavorites: Binding<Bool>) {
    self._isShowingAddToFavorites = isShowingAddToFavorites
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
          Text(journeyQuery.query.dateMode.description)
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
    .toolbar {
      ToolbarItemGroup(placement: .navigationBarLeading) {
        Button(action: {
          presentationMode.wrappedValue.dismiss()
        }, label: {
          HStack(spacing: 4) {
            Image(systemName: "chevron.backward")
              .font(Font.title2.weight(.medium))
            Text("Tog")
          }
        })
        .offset(x: -8)
      }
      ToolbarItemGroup(placement: .navigationBarTrailing) {
        toolbarItems
      }
    }
    .sheet(isPresented: $isShowingAddToFavorites) {
      AddToFavoritesView(origin: journeyQuery.query.origin, destination: journeyQuery.query.destination,
                         journeys: journeyQuery.results, existingFavorite: existingFavorite,
                         isPresent: $isShowingAddToFavorites)
    }
  }

  var toolbarItems: some View {
    HStack {
      Button(action: {
        isShowingAddToFavorites = true
      }, label: {
        if existingFavorite != nil {
          Globals.Icons.starFill
        } else {
          Globals.Icons.star
        }
      })
      Button(action: {
        // Swap origin and destination
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
    }
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
