//
//  ClearableInputField.swift
//  tog
//
//  Created by Artem Zhukov on 15.08.21.
//

import SwiftUI

struct ClearableInputField: View {
  private let placeholder: String
  private let id: Int
  @Binding private var text: String
  @Binding private var isEditing: Bool
  var body: some View {
    HStack {
      InputField(placeholder, id: id, text: $text, isEditing: $isEditing)
      if isEditing {
        Button(action: { text = "" }, label: {
          Globals.Icons.clear
            .foregroundColor(.primary)
            .opacity(0.3)
        })
        .buttonStyle(PlainButtonStyle())
      }
    }
  }
  init(_ placeholder: String, id: Int, text: Binding<String>, isEditing: Binding<Bool>) {
    self.placeholder = placeholder
    self.id = id
    self._text = text
    self._isEditing = isEditing
  }
}

private struct ClearableInputFieldAdjustedForPreview: View {
  @Binding var isEditing: Bool
  var body: some View {
    ClearableInputField("Search Field", id: 0, text: .constant(""), isEditing: $isEditing)
      .frame(width: 300, height: 14)
      .previewLayout(.sizeThatFits)
      .padding()
  }
}

struct ClearableInputField_Previews: PreviewProvider {
  static var previews: some View {
    ClearableInputFieldAdjustedForPreview(isEditing: .constant(false))
    ClearableInputFieldAdjustedForPreview(isEditing: .constant(true))
    ClearableInputFieldAdjustedForPreview(isEditing: .constant(true))
      .preferredColorScheme(.dark)
  }
}
