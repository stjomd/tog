//
//  TicketsView.swift
//  tog
//
//  Created by Artem Zhukov on 12.08.21.
//

import SwiftUI

struct TicketsView: View {

  @ObservedObject private var validTicketsQuery   = TicketsQuery(.valid)
  @ObservedObject private var expiredTicketsQuery = TicketsQuery(.expired)

  var body: some View {
    NavigationView {
      List {

        // Discounts - future update
        // Section(header: Text("Discounts")) {
        //   Text("Benefitcard")
        // }

        // No tickets card
        if validTicketsQuery.results.isEmpty && expiredTicketsQuery.results.isEmpty {
          VStack {
            Image(systemName: "ticket")
              .resizable()
              .scaledToFit()
              .frame(width: 50, height: 50)
            HStack {
              Spacer()
              Text("No tickets")
                .font(.title3)
                .bold()
              Spacer()
            }
          }
          .padding(.vertical, 8)
          .opacity(0.5)
        }
        // Valid tickets
        if !validTicketsQuery.results.isEmpty {
          Section(header: Text("Valid Tickets")) {
            ForEach(validTicketsQuery.results, id: \.id) { ticket in
              TicketPreview(ticket: ticket)
            }
          }
        }
        // Expired tickets
        if !expiredTicketsQuery.results.isEmpty {
          Section(header: Text("Expired Tickets")) {
            ForEach(expiredTicketsQuery.results, id: \.id) { ticket in
              TicketPreview(ticket: ticket)
                .opacity(0.3)
            }
          }
        }
      }
      .listStyle(InsetGroupedListStyle())
      .navigationTitle("Tickets")
      .navigationBarTitleDisplayMode(.inline)
      .onAppear {
        // Reload tickets on each screen appear
        validTicketsQuery.reload()
        expiredTicketsQuery.reload()
      }
    }
  }

}

struct TicketsView_Previews: PreviewProvider {
  static var previews: some View {
    TicketsView()
  }
}
