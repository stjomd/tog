//
//  Buttons.swift
//  tog
//
//  Created by Artem Zhukov on 04.10.21.
//

import SwiftUI

struct FlatButton<Contents: View>: View {

  let disabled: Bool
  let action: () -> Void
  let contents: () -> Contents

  init(disabled: Bool, action: @escaping () -> Void, @ViewBuilder contents: @escaping () -> Contents) {
    self.disabled = disabled
    self.action = action
    self.contents = contents
  }

  var body: some View {
    Button(action: action, label: {
      ZStack {
        RoundedRectangle(cornerRadius: 6)
          .foregroundColor(disabled ? .gray : .blue)
        HStack {
          contents()
        }
        .foregroundColor(.white)
        .padding(.vertical, 6)
      }
    })
    .disabled(disabled)
  }

}

struct Buttons_Previews: PreviewProvider {
  static var previews: some View {
    FlatButton(disabled: false, action: {}, contents: { Text("Button") })
      .previewLayout(.sizeThatFits)
      .frame(width: 200, height: 40)
      .padding()
  }
}
