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

  @ObservedObject var originQuery = StopQuery()
  @ObservedObject var destinationQuery = StopQuery()

  @State private var showing = [false, false]

  // Property with meaningless value to force reload of favorite destinations section
  @State private var reloadForcer = false

  private var completedSearch: Bool {
    guard let origin = origin, let destination = destination else { return false }
    // The following line guarantees that the text input & station name match (after a selection)
    return origin.name == originQuery.query && destination.name == destinationQuery.query
  }

  var body: some View {
    NavigationView {
      List {
        Section(header: Text("Buy tickets")) {
          ClearableInputField("Origin", id: 0, text: $originQuery.query, isEditing: $showing[0])
          ClearableInputField("Destination", id: 1, text: $destinationQuery.query, isEditing: $showing[1])
          if completedSearch, let origin = origin, let destination = destination {
            NavigationLink(destination:
              TicketsSearchView(origin: origin, destination: destination)
            ) {
              HStack {
                Image(systemName: "magnifyingglass")
                Text("Find tickets...")
                  .bold()
              }
            }
          }
        }
        DisjunctSections(sections: [
          DisjunctSearchResultsSection(when: $showing[0], results: originQuery.results) { selectedStop in
            originQuery.query = selectedStop.name
            origin = selectedStop
            InputField.focus(on: 1)
          },
          DisjunctSearchResultsSection(when: $showing[1], results: destinationQuery.results) { selectedStop in
            destinationQuery.query = selectedStop.name
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
  init(when condition: Binding<Bool>, results: [Stop],
       _ onFinish: @escaping ((Stop) -> Void)) {
    super.init(when: condition, {
      SearchResultsSection(results: results, onResultTapGesture: onFinish)
    })
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
