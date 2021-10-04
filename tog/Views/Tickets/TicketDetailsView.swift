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

  var body: some View {
    ScrollView(showsIndicators: false) {
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
        .padding(.bottom, 8)
      }
      JourneyLegsPreview(journey: ticket.journey)
        .padding(.horizontal)
        .padding(.bottom, 16)
    }
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
