//
//  SearchResultsSection.swift
//  tog
//
//  Created by Artem Zhukov on 14.08.21.
//

import SwiftUI
import CoreData

struct SearchResultsSection: View {

  private var stops: [Stop] = []
  private var action: (Stop) -> Void

  var body: some View {
    Section(header: Text("Search Results")) {
      if stops.isEmpty {
        Text("No results")
          .opacity(0.3)
      }
      ForEach(stops, id: \.id) { stop in
        Button(action: { action(stop) }, label: {
          Text(stop.name)
            .foregroundColor(.primary)
        })
      }
    }
  }

  init(results: [Stop], onResultTapGesture action: @escaping ((Stop) -> Void) = {_ in return}) {
    self.stops = results
    self.action = action
  }

}

struct SearchResultsSection_Previews: PreviewProvider {
  static var previews: some View {
    List {
      SearchResultsSection(results: [Stop(id: 0, latitude: 0, longitude: 0, name: "Wien")])
    }
    .listStyle(InsetGroupedListStyle())
  }
}
