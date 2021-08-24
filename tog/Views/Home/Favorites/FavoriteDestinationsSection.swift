//
//  FavoriteDestinationsSection.swift
//  tog
//
//  Created by Artem Zhukov on 24.08.21.
//

import SwiftUI

struct FavoriteDestinationsSection: View {

  @ObservedObject private var query = FavoritesQuery()

  var body: some View {
    Section(header: Text("Favorite Destinations")) {
      ForEach(query.results, id: \.self) { favorite in
        FavoriteView(origin: favorite.origin!, destination: favorite.destination!, amount: favorite.amount)
      }
    }
  }

}

// MARK: - Previews

struct FavoriteDestinationsSectionPreview: View {
  var body: some View {
    List {
      FavoriteDestinationsSection()
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
