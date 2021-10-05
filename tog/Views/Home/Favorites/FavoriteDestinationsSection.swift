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
      if favoritesQuery.results.isEmpty {
        HStack {
          Spacer()
          VStack(alignment: .center) {
            Image(systemName: "star.circle")
              .resizable()
              .scaledToFit()
              .frame(width: 50, height: 50)
            Text("Frequented Destinations")
              .font(.title3)
              .bold()
              .multilineTextAlignment(.center)
              .padding(.vertical, 2)
            Text("Add destinations to favorites to always have next departures at hand.")
              .multilineTextAlignment(.center)
              .fixedSize(horizontal: false, vertical: true) // prevents from collapsing to one line
          }
          .padding(.vertical, 8)
          .opacity(0.5)
          Spacer()
        }
      }
      ForEach(favoritesQuery.results, id: \.id) { favorite in
        ZStack {
          FavoriteView(favorite: favorite, favoritesQuery: favoritesQuery)
            .background(
              NavigationLink("", destination: TicketsSearchView(
                origin: favorite.origin!, destination: favorite.destination!,
                favoritesQuery: favoritesQuery
              ))
              .opacity(0) // Hides the navigation link chevron
            )
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
