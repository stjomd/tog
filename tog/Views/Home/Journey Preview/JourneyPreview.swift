//
//  JourneyPreview.swift
//  tog
//
//  Created by Artem Zhukov on 03.10.21.
//

import SwiftUI

struct JourneyPreview: View {

  let journey: Journey

  var body: some View {
    ScrollView(showsIndicators: false) {
      VStack(alignment: .leading) {
        ForEach(journey.legs, id: \.self) { leg in
          Divider()
            .padding(.bottom, 4)
          HStack {
            Globals.Icons.train
            Text(leg.trip.name)
              .fontWeight(.bold)
            Text(leg.trip.headsign)
          }
          ForEach(leg.halts, id: \.id) { halt in
            HaltRow(halt: halt, leg: leg)
          }
          Divider()
            .padding(.bottom, 4)
          if leg.trip.id != journey.legs.last!.trip.id {
            if let transferTime = journey.transferTime(after: leg)?.textualDescription {
              Text("\(transferTime) to transfer in \(leg.halts.last!.stop.name)")
            } else {
              Text("Transfer in \(leg.halts.last!.stop.name)")
            }
          }
        }
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.horizontal)
    .navigationTitle("Journey Preview")
    .navigationBarTitleDisplayMode(.inline)
  }

}

struct HaltRow: View {

  let halt: Halt
  let leg: JourneyLeg

  var body: some View {
    HStack {
      Text("\(halt.departureTime.shortDescription) dep.")
        .frame(width: 85, alignment: .trailing)
      if halt.isFirstIn(leg: leg) {
        // First halt in a leg
        Circle()
          .foregroundColor(.blue)
          .frame(width: 15, height: 15)
        Text(halt.stop.name)
          .bold()
          .lineLimit(1)
        Text("3") // platform - placeholder (not provided in the data)
          .fontWeight(.thin)
      } else if halt.isLastIn(leg: leg) {
        // Last halt in a leg
        Circle()
          .foregroundColor(.blue)
          .frame(width: 15, height: 15)
          .overlay(circleConnector)
        Text(halt.stop.name)
          .bold()
          .lineLimit(1)
        Text("4") // platform - placeholder (not provided in the data)
          .fontWeight(.thin)
      } else {
        // All other halts
        VStack {
          Circle()
            .foregroundColor(.blue)
            .frame(width: 10, height: 10)
            .overlay(circleConnector)
        }
        .frame(width: 15, height: 15, alignment: .center)
        Text(halt.stop.name)
          .lineLimit(1)
      }
    }
  }

  private var circleConnector: some View {
    Rectangle()
      .foregroundColor(.blue)
      .frame(width: 3, height: 25)
      .offset(y: -17)
  }

}

struct JourneyPreview_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      JourneyPreview(journey: .example)
    }
    NavigationView {
      JourneyPreview(journey: .example)
    }
    .preferredColorScheme(.dark)
  }
}
