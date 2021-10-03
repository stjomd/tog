//
//  Buttons.swift
//  tog
//
//  Created by Artem Zhukov on 04.10.21.
//

import SwiftUI

struct FlatButton<Contents: View>: View {

  let action: () -> Void
  let contents: () -> Contents

  init(action: @escaping () -> Void, @ViewBuilder contents: @escaping () -> Contents) {
    self.action = action
    self.contents = contents
  }

  var body: some View {
    Button(action: action, label: {
      ZStack {
        RoundedRectangle(cornerRadius: 6)
          .foregroundColor(.blue)
        HStack {
          contents()
        }
        .foregroundColor(.white)
        .padding(.vertical, 6)
      }
    })
  }

}

struct Buttons_Previews: PreviewProvider {
  static var previews: some View {
    FlatButton(action: {}, contents: { Text("Button") })
      .previewLayout(.sizeThatFits)
      .frame(width: 200, height: 40)
      .padding()
  }
}
