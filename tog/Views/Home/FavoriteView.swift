//
//  FavoriteView.swift
//  tog
//
//  Created by Artem Zhukov on 11.08.21.
//

import SwiftUI

struct FavoriteView: View {

  let origin: String
  let destination: String
  var journeys: [Journey]

  var body: some View {
    VStack(alignment: .leading) {
      // Title
      HStack(alignment: .firstTextBaseline) {
        VStack(alignment: .leading) {
          HStack(spacing: 6) {
            Text("\(origin)")
              .font(.headline)
            Globals.Icons.rightArrow
              .foregroundColor(.gray)
          }
          Text(destination)
            .font(.headline)
        }
        Spacer()
        Globals.Icons.more
      }
      // Trips
      ForEach(journeys, id: \.self) { journey in
        JourneyRow(journey: journey)
      }
    }
    .padding(.vertical, 10)
  }

}

struct FavoriteJourneyView_Previews: PreviewProvider {
  static var previews: some View {

    FavoriteView(origin: "Wien Penzing", destination: "Wien Westbahnhof",
                 journeys: [Journey.example])
      .previewLayout(.sizeThatFits)
      .padding()

    FavoriteView(origin: "Wien Penzing", destination: "Wien Westbahnhof",
                 journeys: [Journey.example])
      .preferredColorScheme(.dark)
      .previewLayout(.sizeThatFits)
      .padding()

    List {
      FavoriteView(origin: "Wien Penzing", destination: "Wien Westbahnhof",
                   journeys: [Journey.example])
    }
    .listStyle(InsetGroupedListStyle())

  }
}
