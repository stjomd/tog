//
//  SettingsView.swift
//  tog
//
//  Created by Artem Zhukov on 12.08.21.
//

import SwiftUI

struct SettingsView: View {
  var body: some View {
    NavigationView {
      List {
        Section {
          VStack(alignment: .leading) {
            Text("Max Mustermann")
              .bold()
            Text("max.mustermann@gmx.at")
              .font(.subheadline)
              .opacity(0.5)
          }
          .padding(.vertical, 4)
        }
        Section {
          SettingsRow("Account Settings", icon: .sfSymbol("gearshape.fill"))
          SettingsRow("Personal Details", icon: .sfSymbol("person.fill"))
          SettingsRow("Payment Methods", icon: .sfSymbol("creditcard.fill"))
          SettingsRow("Newsletters, Specials & News", icon: .sfSymbol("envelope.fill"))
        }
        Section {
          SettingsRow("Help", icon: .sfSymbol("questionmark.circle.fill"))
          SettingsRow("Support", icon: .sfSymbol("person.fill.questionmark"))
        }
        Section {
          SettingsRow("Passengers' Rights")
          SettingsRow("Privacy Policy")
          SettingsRow("Legal Information")
        }
        Section {
          Text("Log out")
            .foregroundColor(.red)
        }
      }
      .listStyle(InsetGroupedListStyle())
      .navigationBarTitleDisplayMode(.inline)
      .navigationBarTitle("Settings")
    }
  }
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView()
  }
}
