//
//  TicketsView.swift
//  tog
//
//  Created by Artem Zhukov on 12.08.21.
//

import SwiftUI

struct TicketsView: View {
  var body: some View {
    NavigationView {
      List {
        Section(header: Text("Discounts")) {
          Text("Benefitcard")
        }
        Section(header: Text("Valid Tickets")) {
          TicketPreview()
        }
        Section(header: Text("Expired Tickets")) {
          TicketPreview()
          TicketPreview()
        }
      }
      .listStyle(InsetGroupedListStyle())
      .navigationTitle("Tickets")
      .navigationBarTitleDisplayMode(.inline)
    }
  }
}

struct TicketsView_Previews: PreviewProvider {
  static var previews: some View {
    TicketsView()
  }
}
