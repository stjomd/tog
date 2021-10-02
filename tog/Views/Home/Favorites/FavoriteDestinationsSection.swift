//
//  FavoriteDestinationsSection.swift
//  tog
//
//  Created by Artem Zhukov on 24.08.21.
//

import SwiftUI

struct FavoriteDestinationsSection: View {

  @ObservedObject var favoritesQuery: FavoritesQuery

  var body: some View {
    Section(header: Text("Favorite Destinations")) {
      ForEach(favoritesQuery.results, id: \.id) { favorite in
        ZStack {
          FavoriteView(favorite: favorite, favoritesQuery: favoritesQuery)
          // Trick to hide navigation link arrow
          NavigationLink(
            destination: TicketsSearchView(
              origin: favorite.origin!,
              destination: favorite.destination!,
              favoritesQuery: favoritesQuery
            )
          ) {
            EmptyView()
          }
          .hidden()
        }
      }
    }
  }

}

// MARK: - Previews

struct FavoriteDestinationsSectionPreview: View {
  var body: some View {
    List {
      FavoriteDestinationsSection(favoritesQuery: FavoritesQuery())
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
