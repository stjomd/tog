//
//  ServicesView.swift
//  tog
//
//  Created by Artem Zhukov on 12.08.21.
//

import SwiftUI

struct ServicesView: View {
  var body: some View {
    NavigationView {
      List {
        Section(header: Text("Popular Products")) {
          ProductCell(title: "Easy-Out-Ticket", description: "Local transport tickets for 2–5 passengers", image: Image(systemName: "person.2.fill"))
          ProductCell(title: "Summer Ticket", description: "Youth special for holders of Benefitscard", image: Image(systemName: "sun.max.fill"))
          ProductCell(title: "Vienna", description: "City tickets for trips in Vienna")
          ProductCell(title: "Graz", description: "City tickets for trips in Graz (zone 101)")
          ProductCell(title: "Linz", description: "City tickets for trips in Linz")
          ProductCell(title: "Salzburg", description: "City tickets for trips in Salzburg (city centre)")
        }
        Section(header: Text("Other Products")) {
          ProductCell(title: "Benefitscard", description: "Buy annually and enjoy Tog services at reduced prices", image: Image(systemName: "creditcard.fill"))
          ProductCell(title: "Shared Mobility", description: "Rent cars and e-bikes", image: Image(systemName: "personalhotspot"))
          ProductCell(title: "Special Price Tickets", description: "Save money", image: Image(systemName: "eurosign.circle.fill"))
          ProductCell(title: "City Tickets", description: "Tickets for public transport in cities", image: Image(systemName: "figure.walk"))
          ProductCell(title: "Regional Tickets", description: "Regional specials across Austria", image: Image(systemName: "bus.fill"))
          ProductCell(title: "Combination Tickets", description: "Train tickets with tourist specials", image: Image(systemName: "sparkles"))
          ProductCell(title: "Tog+", description: "Tourist specials at reduced prices", image: Image(systemName: "cross.fill"))
          ProductCell(title: "Neighbouring countries", description: "Tickets for Slovakia, Germany, Switzerland and more", image: Image(systemName: "figure.walk"))
          ProductCell(title: "Travel Insurance", description: "Cancellation cover and travel insurance", image: Image(systemName: "shield.fill"))
        }
      }
      .listStyle(InsetGroupedListStyle())
      .navigationBarTitle("Services")
      .navigationBarTitleDisplayMode(.inline)
    }
  }
}

struct ServicesView_Previews: PreviewProvider {
  static var previews: some View {
    ServicesView()
  }
}
