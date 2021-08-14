//
//  ContentView.swift
//  tog
//
//  Created by Artem Zhukov on 11.08.21.
//

import SwiftUI

struct HomeView: View {
  
  @State var originQuery: String = ""
  @State var destinationQuery: String = ""
  
  @State var origin: Stop? = nil
  @State var destination: Stop? = nil
  
  @State var showingOriginSearchResults = false
  @State var showingDestinationSearchResults = false
  
  var body: some View {
    NavigationView {
      List {
        Section(header: Text("Buy tickets")) {
          InputField("Origin", id: 1, text: $originQuery, isEditing: $showingOriginSearchResults)
          InputField("Destination", id: 2, text: $destinationQuery, isEditing: $showingDestinationSearchResults)
        }
        if showingOriginSearchResults {
          SearchResultsSection(query: $originQuery) { selectedStop in
            origin = selectedStop
            InputField.focus(on: 2)
          }
        } else if showingDestinationSearchResults {
          SearchResultsSection(query: $destinationQuery) { selectedStop in
            destination = selectedStop
            InputField.unfocus(from: 2)
          }
        } else {
          Section(header: Text("Favorite Destinations")) {
            FavoriteView(origin: "Wien Penzing", destination: "Wien Westbahnhof", journeys: [Journey.s50, Journey.s50, Journey.rex])
            FavoriteView(origin: "Wien", destination: "Flughafen Wien", journeys: [Journey.s45, Journey.s45])
          }
        }
      }
      .listStyle(InsetGroupedListStyle())
      .navigationTitle("Tog")
    }
  }
  
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
    HomeView()
      .preferredColorScheme(.dark)
  }
}
