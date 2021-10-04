//
//  TicketPreview.swift
//  tog
//
//  Created by Artem Zhukov on 12.08.21.
//

import SwiftUI

struct TicketPreview: View {

  let ticket: Ticket

  private var dateFormatter: DateFormatter {
    let df = DateFormatter()
    df.dateFormat = "HH:mm"
    return df
  }

  var body: some View {
    ZStack {
      VStack(alignment: .leading) {
        // Title
        TicketTitle(ticket: ticket)
        // Trips
        JourneyRow(journey: ticket.journey)
        HStack {
          Globals.Icons.person
            .padding(.trailing, -4)
          Text("\(ticket.passengers)")
          Spacer()
          Globals.Icons.clock
            .padding(.trailing, -4)
          Text(ticket.expirationString)
        }
        .opacity(0.4)
      }
      .padding(.vertical, 10)
      // Navigation link without chevron
      NavigationLink("", destination: TicketDetailsView(ticket: ticket))
        .opacity(0)
    }
  }

}

struct TicketTitle: View {

  let ticket: Ticket

  var body: some View {
    VStack(alignment: .leading) {
      HStack(spacing: 6) {
        Text(ticket.origin.name)
          .font(.headline)
        Globals.Icons.rightArrow
          .foregroundColor(.gray)
      }
      Text(ticket.destination.name)
        .font(.headline)
    }
  }

}

struct TicketPreview_Previews: PreviewProvider {
  static var previews: some View {
    TicketPreview(ticket: .valid)
      .previewLayout(.sizeThatFits)
      .padding()
    TicketPreview(ticket: .expired)
      .previewLayout(.sizeThatFits)
      .preferredColorScheme(.dark)
      .padding()
    List {
      TicketPreview(ticket: .valid)
    }
    .listStyle(InsetGroupedListStyle())
  }
}
