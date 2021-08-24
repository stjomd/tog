//
//  FavoriteDestinationsSection.swift
//  tog
//
//  Created by Artem Zhukov on 24.08.21.
//

import SwiftUI

struct FavoriteDestinationsSection: View {

  let query: FavoritesQuery

  var body: some View {
    Section(header: Text("Favorite Destinations")) {
      ForEach(query.results, id: \.id) { favorite in
          FavoriteView(favorite: favorite, query: query)
      }
    }
  }

}

// MARK: - Previews

struct FavoriteDestinationsSectionPreview: View {
  var body: some View {
    List {
      FavoriteDestinationsSection(query: FavoritesQuery())
    }
    .listStyle(InsetGroupedListStyle())
  }
}

struct FavoriteDestinationsSection_Previews: PreviewProvider {
  static var previews: some View {
    FavoriteDestinationsSectionPreview()
    FavoriteDestinationsSectionPreview()
      .preferredColorScheme(.dark)
  }
}
