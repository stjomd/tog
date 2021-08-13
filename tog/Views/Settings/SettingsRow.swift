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
  
  let title: String
  let icon: Icon?
  
  private var iconColor: Color
  private var iconBackgroundColor: Color
  
  init(_ title: String, icon: Icon? = nil) {
    self.title = title
    self.icon = icon
    // Color setup
    let colorComponents = ColorService.components(from: title)
    self.iconBackgroundColor = colorComponents.color
    self.iconColor = colorComponents.contrastingColor(bright: .white, dark: .black)
  }
  
  var body: some View {
    HStack(alignment: .center) {
      if let icon = icon {
        switch icon {
        case .letter:
          iconBackground
            .overlay(
              Text(String(title.first ?? " "))
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(iconColor)
            )
        case let .sfSymbol(systemName):
          iconBackground
            .overlay(
              Image(systemName: systemName)
                .font(.callout)
                .foregroundColor(iconColor)
            )
        }
      }
      Text(title)
        .padding(.leading, icon == nil ? 0 : 4)
    }
    .padding(.vertical, 4)
  }
  
  var iconBackground: some View {
    RoundedRectangle(cornerSize: CGSize(width: 6, height: 6))
      .foregroundColor(iconBackgroundColor)
      .frame(width: 28, height: 28)
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
      SettingsRow("Support")
    }
    .listStyle(InsetGroupedListStyle())
  }
}
