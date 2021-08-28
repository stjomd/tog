//
//  FavoriteDestinationsSection.swift
//  tog
//
//  Created by Artem Zhukov on 24.08.21.
//

import SwiftUI

struct FavoriteDestinationsSection: View {

  @StateObject private var query = FavoritesQuery()

  @Binding var favorites: [FavoriteDestination]

  var body: some View {
    Section(header: Text("Favorite Destinations")) {
      ForEach(favorites, id: \.id) { favorite in
        FavoriteView(favorite: favorite, query: query)
      }
    }
  }

}

// MARK: - Previews

struct FavoriteDestinationsSectionPreview: View {
  var body: some View {
    List {
      FavoriteDestinationsSection(favorites: .constant([
        .init(origin: Stop.penzing, destination: Stop.westbahnhof, amount: 2)
      ]))
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
