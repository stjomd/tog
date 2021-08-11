//
//  FavoriteView.swift
//  tog
//
//  Created by Artem Zhukov on 11.08.21.
//

import SwiftUI

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
            Image(systemName: "arrow.right")
              .foregroundColor(.gray)
          }
          Text(destination)
            .font(.headline)
        }
        Spacer()
        Image(systemName: "ellipsis.circle")
      }
      // Trips
      ForEach(journeys, id: \.self) { journey in
        JourneyRow(journey: journey)
      }
    }
    .padding(.vertical, 10)
  }
  
}

struct JourneyRow: View {
  
  let journey: Journey
  var dateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    return formatter
  }
  
  var body: some View {
    HStack {
      Text("\(dateFormatter.string(from: journey.departure)) dep.")
      Rectangle()
        .foregroundColor(.gray.opacity(0.2))
        .overlay(
          Rectangle()
            .foregroundColor(color(for: journey.train))
            .frame(height: 2),
          alignment: .bottom
        )
        .overlay(
          Text(journey.train)
            .font(.callout)
        )
        .frame(height: 28)
      Text("arr. \(dateFormatter.string(from: journey.arrival))")
    }
  }
  
  private func color(for train: String) -> Color {
    switch train {
    case "REX":
      return Globals.Colors.Transport.rex
    case _ where train.hasPrefix("S"):
      return Globals.Colors.Transport.sBahn
    default:
      return Globals.Colors.Transport.other
    }
  }
  
}

struct FavoriteJourneyView_Previews: PreviewProvider {
  static var previews: some View {
    
    FavoriteView(origin: "Wien Penzing", destination: "Wien Westbahnhof", journeys: [Journey.s50, Journey.rex])
      .previewLayout(.sizeThatFits)
      .padding()
    
    FavoriteView(origin: "Wien Penzing", destination: "Wien Westbahnhof", journeys: [Journey.s50, Journey.rex])
      .preferredColorScheme(.dark)
      .previewLayout(.sizeThatFits)
      .padding()
    
    List {
      FavoriteView(origin: "Wien Penzing", destination: "Wien Westbahnhof", journeys: [Journey.s50, Journey.rex])
    }
    .listStyle(InsetGroupedListStyle())
    
  }
}
