//
//  SearchResultsSection.swift
//  tog
//
//  Created by Artem Zhukov on 14.08.21.
//

import SwiftUI
import CoreData

struct SearchResultsSection: View {
  
  @Binding var query: String
  
  private var fetchRequest: FetchRequest<Stop>
  private var stops: FetchedResults<Stop> {
    fetchRequest.wrappedValue
  }
  
  private var action: (Stop) -> Void
  
  var body: some View {
    Section(header: Text("Search Results")) {
      ForEach(stops, id: \.id) { stop in
        Button(action: {
          query = stop.name
          action(stop)
        }) {
          Text(stop.name)
            .foregroundColor(.primary)
        }
      }
    }
  }
  
  init(query: Binding<String>,
       onResultTapGesture action: @escaping ((Stop) -> Void) = {_ in return}) {
    self._query = query
    self.fetchRequest = FetchRequest<Stop>(
      entity: Stop.entity(),
      sortDescriptors: [],
      predicate: NSPredicate(format: "name CONTAINS[cd] %@", query.wrappedValue)
    )
    self.action = action
  }
  
}
