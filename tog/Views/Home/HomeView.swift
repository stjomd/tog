//
//  ContentView.swift
//  tog
//
//  Created by Artem Zhukov on 11.08.21.
//

import SwiftUI

struct HomeView: View {
  
  @State var origin: String = "Wien Penzing"
  @State var destination: String = ""
  
  var body: some View {
    NavigationView {
      List {
        Section(header: Text("Buy tickets")) {
          HStack {
            TextField("Origin", text: $origin)
            Spacer()
            Globals.Icons.location
          }
          TextField("Destination", text: $destination)
        }
        Section(header: Text("Favorite Destinations")) {
          FavoriteView(origin: "Wien Penzing", destination: "Wien Westbahnhof", journeys: [Journey.s50, Journey.s50, Journey.rex])
          FavoriteView(origin: "Wien", destination: "Flughafen Wien", journeys: [Journey.s45, Journey.s45])
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
