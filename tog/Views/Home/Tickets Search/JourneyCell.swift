//
//  JourneyCell.swift
//  tog
//
//  Created by Artem Zhukov on 22.08.21.
//

import SwiftUI

struct JourneyCell: View {

  let journey: Journey

  var body: some View {
    VStack {
      JourneyRow(journey: journey)
      HStack {
        Globals.Icons.clock
          .font(.callout)
        Text(journey.durationString)
        Spacer()
        Globals.Icons.money
          .font(.callout)
        Text(journey.priceString)
          .bold()
      }
    }
    .opacity((Date() > journey.departure) ? 0.3 : 1)
    .padding(.vertical, 10)
  }

}

struct JourneyCell_Previews: PreviewProvider {
  static var previews: some View {
    List {
      JourneyCell(journey: Journey.example)
      JourneyCell(journey: Journey.example)
      JourneyCell(journey: Journey.example)
    }
    .listStyle(InsetGroupedListStyle())
  }
}
