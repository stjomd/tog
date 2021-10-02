//
//  FavoriteView.swift
//  tog
//
//  Created by Artem Zhukov on 11.08.21.
//

import SwiftUI

struct FavoriteView: View {

  let favorite: FavoriteDestination

  @ObservedObject private var journeyQuery = JourneyQuery()
  @ObservedObject private var favoritesQuery: FavoritesQuery

  init(favorite: FavoriteDestination, favoritesQuery: FavoritesQuery) {
    self.favorite = favorite
    self.favoritesQuery = favoritesQuery
    journeyQuery.query = .init(
      origin: favorite.origin!, destination: favorite.destination!,
      date: Date(), dateMode: .departure,
      passengers: 1, limit: favorite.amount
    )
  }

  var body: some View {
    VStack(alignment: .leading) {
      FavoriteJourneyTitle(favorite: favorite, isShowingMoreIcon: true, favoritesQuery: favoritesQuery)
      FavoriteJourneyTrips(journeys: journeyQuery.results)
    }
    .padding(.vertical, 10)
  }

}

struct FavoriteJourneyTitle: View {

  @Autowired private var dataService: DataService!

  let favorite: FavoriteDestination
  let isShowingMoreIcon: Bool

  @ObservedObject private var favoritesQuery: FavoritesQuery
  @ObservedObject private var journeyQuery = JourneyQuery()

  @State private var isPresentingEditFavoriteView = false

  var body: some View {
    HStack(alignment: .firstTextBaseline) {
      VStack(alignment: .leading) {
        HStack(spacing: 6) {
          Text(favorite.origin!.name)
            .font(.headline)
            .lineLimit(1)
          Globals.Icons.rightArrow
            .foregroundColor(.gray)
        }
        Text(favorite.destination!.name)
          .font(.headline)
          .lineLimit(1)
      }
      if isShowingMoreIcon {
        Spacer()
        Menu(content: {
          // Edit button
          Button(action: {
            isPresentingEditFavoriteView = true
          }, label: {
            Label("Edit", systemImage: "square.and.pencil")
          })
          // Remove button
          Button(action: {
            favoritesQuery.results.removeAll { $0.id == favorite.id }
            dataService.deleteFavorite(favorite)
          }, label: {
            Label("Delete", systemImage: "trash")
          })
        }, label: {
          Globals.Icons.more
        })
        .foregroundColor(.primary)
      }
    }
    .sheet(isPresented: $isPresentingEditFavoriteView) {
      AddToFavoritesView(
        origin: favorite.origin!, destination: favorite.destination!,
        journeys: journeyQuery.results, existingFavorite: favorite,
        isPresent: $isPresentingEditFavoriteView, favoritesQuery: favoritesQuery
      )
    }
  }

  init(favorite: FavoriteDestination, isShowingMoreIcon: Bool, favoritesQuery: FavoritesQuery) {
    self.favorite = favorite
    self.isShowingMoreIcon = isShowingMoreIcon
    self.favoritesQuery = favoritesQuery
    self.journeyQuery.query = .init(
      origin: favorite.origin!, destination: favorite.destination!,
      date: Date(), dateMode: .departure,
      passengers: 1, limit: 5
    )
  }

}

struct FavoriteJourneyTrips: View {
  let journeys: [Journey]
  var body: some View {
    if !journeys.isEmpty {
      ForEach(journeys, id: \.self) { journey in
        JourneyRow(journey: journey)
      }
    } else {
      Text("No journeys")
        .padding(.top, 2)
        .opacity(0.3)
    }
  }
}

struct FavoriteJourneyView_Previews: PreviewProvider {

  static let fav = FavoriteDestination(origin: Stop.penzing, destination: Stop.westbahnhof, amount: 3)

  static var previews: some View {

    FavoriteView(favorite: fav, favoritesQuery: FavoritesQuery())
      .previewLayout(.sizeThatFits)
      .padding()

    FavoriteView(favorite: fav, favoritesQuery: FavoritesQuery())
      .preferredColorScheme(.dark)
      .previewLayout(.sizeThatFits)
      .padding()

    List {
      FavoriteView(favorite: fav, favoritesQuery: FavoritesQuery())
    }
    .listStyle(InsetGroupedListStyle())

  }
}
