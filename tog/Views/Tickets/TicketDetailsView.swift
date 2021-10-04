//
//  TicketDetailsView.swift
//  tog
//
//  Created by Artem Zhukov on 04.10.21.
//

import SwiftUI

struct TicketDetailsView: View {

  let ticket: Ticket

  var body: some View {
    ScrollView(showsIndicators: false) {
      JourneyLegsPreview(journey: ticket.journey)
        .padding(.horizontal)
        .padding(.bottom, 16)
    }
    .navigationTitle("Ticket")
  }

}

struct TicketDetailsView_Previews: PreviewProvider {
  static var previews: some View {
    TicketDetailsView(ticket: .valid)
  }
}
