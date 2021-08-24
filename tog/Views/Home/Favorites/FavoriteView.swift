//
//  FavoriteView.swift
//  tog
//
//  Created by Artem Zhukov on 11.08.21.
//

import SwiftUI

struct FavoriteView: View {

  let favorite: FavoriteDestination
  let query: FavoritesQuery

  @ObservedObject private var journeyQuery = JourneyQuery()

  init(favorite: FavoriteDestination, query: FavoritesQuery) {
    self.favorite = favorite
    self.query = query
    journeyQuery.query = .init(
      origin: favorite.origin!, destination: favorite.destination!,
      date: Date(), dateMode: .departure,
      passengers: 1, limit: favorite.amount
    )
  }

  var body: some View {
    VStack(alignment: .leading) {
      FavoriteJourneyTitle(favorite: favorite, query: query, isShowingMoreIcon: true)
      FavoriteJourneyTrips(journeys: journeyQuery.results)
    }
    .padding(.vertical, 10)
  }

}

struct FavoriteJourneyTitle: View {

  @Autowired private var dataService: DataService!

  let favorite: FavoriteDestination
  let query: FavoritesQuery?
  let isShowingMoreIcon: Bool

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
          Button(action: {
            if let query = query {
              query.results.removeAll { $0.id == favorite.id }
            }
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

    FavoriteView(favorite: fav, query: FavoritesQuery())
      .previewLayout(.sizeThatFits)
      .padding()

    FavoriteView(favorite: fav, query: FavoritesQuery())
      .preferredColorScheme(.dark)
      .previewLayout(.sizeThatFits)
      .padding()

    List {
      FavoriteView(favorite: fav, query: FavoritesQuery())
    }
    .listStyle(InsetGroupedListStyle())

  }
}
