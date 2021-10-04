//
//  TicketPreview.swift
//  tog
//
//  Created by Artem Zhukov on 12.08.21.
//

import SwiftUI

struct TicketPreview: View {

  let ticket: Ticket

  private var origin: Stop {
    ticket.journey.legs.first!.halts.first!.stop
  }
  private var destination: Stop {
    ticket.journey.legs.last!.halts.last!.stop
  }

  private var dateFormatter: DateFormatter {
    let df = DateFormatter()
    df.dateFormat = "HH:mm"
    return df
  }

  var body: some View {
    VStack(alignment: .leading) {
      // Title
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
      // Trips
      JourneyRow(journey: ticket.journey)
      HStack {
        Image(systemName: "person")
          .padding(.trailing, -4)
        Text("\(ticket.passengers)")
        Spacer()
        Image(systemName: "clock")
          .padding(.trailing, -4)
        Text(ticket.expirationString)
      }
      .opacity(0.4)
    }
    .padding(.vertical, 10)
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
