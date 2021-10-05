//
//  SettingsRow.swift
//  tog
//
//  Created by Artem Zhukov on 13.08.21.
//

import SwiftUI

struct SettingsRow: View {

  enum Icon {
    case letter
    case sfSymbol(String)
  }

  private let title: String
  private let icon: Icon?

  private var iconSystemName: String? {
    guard let icon = icon else { return nil }
    switch icon {
    case .letter:
      guard let first = title.first else { return nil }
      let letter = String(first).lowercased()
      return "\(letter).circle"
    case let .sfSymbol(systemName):
      return systemName
    }
  }

  init(_ title: String, icon: Icon? = nil) {
    self.title = title
    self.icon = icon
  }

  var body: some View {
    HStack(alignment: .center) {
      if let systemName = iconSystemName {
        Image(systemName: systemName)
          .resizable()
          .font(Font.body.bold())
          .aspectRatio(contentMode: .fit)
          .frame(width: 20, height: 20)
          .padding(.trailing, 4)
      }
      Text(title)
    }
  }
}

struct SettingsRow_Previews: PreviewProvider {
  static var previews: some View {
    SettingsRow("Account Settings", icon: .sfSymbol("gearshape"))
      .previewLayout(.sizeThatFits)
      .padding()
    SettingsRow("Personal Details", icon: .letter)
      .previewLayout(.sizeThatFits)
      .preferredColorScheme(.dark)
      .padding()
    List {
      SettingsRow("Payment Methods", icon: .letter)
      SettingsRow("Support", icon: .sfSymbol("person.fill"))
      SettingsRow("Support")
    }
    .listStyle(InsetGroupedListStyle())
  }
}
