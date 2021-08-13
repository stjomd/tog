//
//  TicketPreview.swift
//  tog
//
//  Created by Artem Zhukov on 12.08.21.
//

import SwiftUI

struct TicketPreview: View {
  let journey = Journey.cjx
  var body: some View {
    VStack(alignment: .leading) {
      // Title
      VStack(alignment: .leading) {
        HStack(spacing: 6) {
          Text("\(journey.origin)")
            .font(.headline)
          Globals.Icons.rightArrow
            .foregroundColor(.gray)
        }
        Text(journey.destination)
          .font(.headline)
      }
      // Trips
      JourneyRow(journey: journey)
    }
    .padding(.vertical, 10)
  }
}

struct TicketPreview_Previews: PreviewProvider {
  static var previews: some View {
    TicketPreview()
      .previewLayout(.sizeThatFits)
      .padding()
    TicketPreview()
      .previewLayout(.sizeThatFits)
      .preferredColorScheme(.dark)
      .padding()
    List {
      TicketPreview()
    }
    .listStyle(InsetGroupedListStyle())
  }
}
