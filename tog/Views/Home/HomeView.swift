//
//  HomeView.swift
//  tog
//
//  Created by Artem Zhukov on 11.08.21.
//

import SwiftUI

struct HomeView: View {

  @State private var origin: Stop?
  @State private var destination: Stop?

  @State private var query = ["", ""]
  @State private var showing = [false, false]

  private var completedSearch: Bool {
    guard let origin = origin, let destination = destination else { return false }
    // The following line guarantees that the text input & station name match (after a selection)
    return origin.name == query[0] && destination.name == query[1]
  }

  var body: some View {
    NavigationView {
      List {
        Section(header: Text("Buy tickets")) {
          ClearableInputField("Origin", id: 0, text: $query[0], isEditing: $showing[0])
          ClearableInputField("Destination", id: 1, text: $query[1], isEditing: $showing[1])
          if completedSearch, let origin = origin, let destination = destination {
            NavigationLink(destination: TicketsSearchView(origin: origin, destination: destination)) {
              HStack {
                Image(systemName: "magnifyingglass")
                Text("Find tickets...")
                  .bold()
              }
            }
          }
        }
        DisjunctSections(sections: [
          DisjunctSearchResultsSection(when: $showing[0], query: $query[0]) { selectedStop in
            origin = selectedStop
            InputField.focus(on: 1)
          },
          DisjunctSearchResultsSection(when: $showing[1], query: $query[1]) { selectedStop in
            destination = selectedStop
            InputField.unfocus(from: 1)
          }
        ], otherwise: {
          FavoriteDestinationsSection()
        })
      }
      .listStyle(InsetGroupedListStyle())
      .navigationTitle("Tog")
    }
  }

}

// MARK: - Wrapper for a disjunct results section
class DisjunctSearchResultsSection: DisjunctSection<SearchResultsSection> {
  init(when condition: Binding<Bool>, query: Binding<String>,
       _ onFinish: @escaping ((Stop) -> Void)) {
    super.init(when: condition, {
      SearchResultsSection(query: query, onResultTapGesture: onFinish)
    })
  }
}

// MARK: - Wrapper for an 'otherwise' section
struct FavoriteDestinationsSection: View {
  var body: some View {
    Section(header: Text("Favorite Destinations")) {
      FavoriteView(origin: "Wien Penzing", destination: "Wien Westbahnhof",
                   journeys: [Journey.s50, Journey.s50, Journey.rex])
      FavoriteView(origin: "Wien", destination: "Flughafen Wien",
                   journeys: [Journey.s45, Journey.s45])
    }
  }
}

// MARK: - Previews
struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
    HomeView()
      .preferredColorScheme(.dark)
  }
}
