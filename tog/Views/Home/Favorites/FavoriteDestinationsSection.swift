//
//  FavoriteDestinationsSection.swift
//  tog
//
//  Created by Artem Zhukov on 24.08.21.
//

import SwiftUI
import RealmSwift

struct FavoriteDestinationsSection: View {

  @Autowired private var realm: Realm!
  private var favorites: [FavoriteDestination] = []

  var body: some View {
    Section(header: Text("Favorite Destinations")) {
      ForEach(favorites, id: \.self) { favorite in
        FavoriteView(origin: favorite.origin!, destination: favorite.destination!, amount: favorite.amount)
      }
    }
  }

  init() {
    self.favorites = Array(realm.objects(FavoriteDestination.self))
    print(favorites)
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
