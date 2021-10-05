//
//  TicketDetailsView.swift
//  tog
//
//  Created by Artem Zhukov on 04.10.21.
//

import SwiftUI
import EFQRCode

struct TicketDetailsView: View {

  let ticket: Ticket

  // Simulated train status
  private var status: some View {
    let rand = Int.random(in: 0..<3)
    let options: (String, Color)
    if rand == 0 {
      options = ("On Time", .green)
    } else if rand == 1 {
      options = ("Delayed", .yellow)
    } else {
      options = ("Cancelled", .red)
    }
    return Text(options.0)
      .bold()
      .foregroundColor(options.1)
  }

  var body: some View {
    ScrollView(showsIndicators: false) {
      VStack(alignment: .leading) {
        // Destination
        HStack(alignment: .top) {
          TicketTitle(ticket: ticket)
          Spacer()
          // Status
          if ticket.isValid {
            status
          }
        }
        .padding(.bottom, 1)
        // Quick view
        JourneyRow(journey: ticket.journey)
        // Infos
        HStack {
          Globals.Icons.person
            .padding(.trailing, -2)
          Text(ticket.passengers.description)
            .padding(.trailing, 10)
          Globals.Icons.money
            .padding(.trailing, -2)
          Text(ticket.journey.priceString)
          Spacer()
          Globals.Icons.clock
            .padding(.trailing, -2)
          Text(ticket.expirationString)
        }
        .opacity(0.4)
      }
      .padding(.top, 10)
      // QR Code
      if let qrCode = qr() {
        ZStack {
          RoundedRectangle(cornerRadius: 16)
            .foregroundColor(.white)
            .frame(width: 170, height: 170)
            .shadow(color: Color.black.opacity(0.2), radius: 3, y: 2)
          qrCode
            .resizable()
            .scaledToFit()
            .frame(width: 150, height: 150)
        }
        .padding(.top, 6)
        .padding(.bottom, 16)
      }
      // Legs Preview
      JourneyLegsPreview(journey: ticket.journey)
        .padding(.bottom, 16)
    }
    .padding(.horizontal)
    .navigationTitle("Ticket")
  }

  private func qr() -> Image? {
    guard let data = try? JSONEncoder().encode(ticket) else {
      return nil
    }
    let string = String(String(decoding: data, as: UTF8.self).prefix(70))
    // Generate QR code
    var image: Image?
    if let qr = EFQRCode.generate(for: string) {
      image = Image(decorative: qr, scale: 1)
    }
    return image
  }

}

struct TicketDetailsView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      TicketDetailsView(ticket: .valid)
        .navigationBarTitleDisplayMode(.inline)
    }
  }
}
