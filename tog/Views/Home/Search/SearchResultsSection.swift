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
  @Autowired var dataService: DataService!
  
  private var stops:  [Stop] = []
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
  
  init(query: Binding<String>, onResultTapGesture action: @escaping ((Stop) -> Void) = {_ in return}) {
    self._query = query
    self.action = action
    self.stops  = dataService.stops(by: query.wrappedValue)
  }
  
}
