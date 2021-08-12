//
//  WrappingTabView.swift
//  tog
//
//  Created by Artem Zhukov on 12.08.21.
//

import SwiftUI

struct MainView: View {
  var body: some View {
    TabView {
      HomeView()
        .tabItem { Label("Home", systemImage: "house") }
      TicketsView()
        .tabItem { Label("Tickets", systemImage: "ticket") }
      OffersView()
        .tabItem { Label("Offers", systemImage: "giftcard") }
      SettingsView()
        .tabItem { Label("Settings", systemImage: "gearshape") }
    }
  }
}

struct WrappingTabView_Previews: PreviewProvider {
  static var previews: some View {
    MainView()
  }
}
