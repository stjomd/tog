//
//  FavoriteView.swift
//  tog
//
//  Created by Artem Zhukov on 11.08.21.
//

import SwiftUI

struct FavoriteView: View {

  let origin: Stop
  let destination: Stop
  let amount: Int

  @ObservedObject private var journeyQuery = JourneyQuery()

  init(origin: Stop, destination: Stop, amount: Int) {
    self.origin = origin
    self.destination = destination
    self.amount = amount
    journeyQuery.query = .init(
      origin: origin, destination: destination, date: Date(), dateMode: .departure, passengers: 1, limit: amount
    )
  }

  var body: some View {
    VStack(alignment: .leading) {
      // Title
      FavoriteJourneyTitle(origin: origin, destination: destination, isShowingMoreIcon: true)
      // Trips
      FavoriteJourneyTrips(journeys: journeyQuery.results)
    }
    .padding(.vertical, 10)
  }

}

struct FavoriteJourneyTitle: View {

  let origin: Stop
  let destination: Stop
  let isShowingMoreIcon: Bool

  var body: some View {
    HStack(alignment: .firstTextBaseline) {
      VStack(alignment: .leading) {
        HStack(spacing: 6) {
          Text(origin.name)
            .font(.headline)
          Globals.Icons.rightArrow
            .foregroundColor(.gray)
        }
        Text(destination.name)
          .font(.headline)
      }
      if isShowingMoreIcon {
        Spacer()
        Globals.Icons.more
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

  static var previews: some View {

    FavoriteView(origin: Stop.penzing, destination: Stop.westbahnhof, amount: 2)
      .previewLayout(.sizeThatFits)
      .padding()

    FavoriteView(origin: Stop.penzing, destination: Stop.westbahnhof, amount: 3)
      .preferredColorScheme(.dark)
      .previewLayout(.sizeThatFits)
      .padding()

    List {
      FavoriteView(origin: Stop.penzing, destination: Stop.westbahnhof, amount: 5)
    }
    .listStyle(InsetGroupedListStyle())

  }
}
