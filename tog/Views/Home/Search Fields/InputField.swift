//
//  InputField.swift
//  tog
//
//  Created by Artem Zhukov on 14.08.21.
//

import SwiftUI

struct InputField: UIViewRepresentable {

  // MARK: - Weak Reference for the dictionary
  final class WeakReference {
    weak var object: UITextField?
    static func to(_ object: UITextField) -> WeakReference {
      let ref = WeakReference()
      ref.object = object
      return ref
    }
  }

  // MARK: - Properties

  private static var container: [Int: WeakReference] = [:]

  private let id: Int
  private let placeholder: String
  @Binding private var text: String
  @Binding private var isEditing: Bool

  // MARK: - Implementation

  static func focus(on id: Int) {
    if let textField = container[id]?.object {
      textField.becomeFirstResponder()
    }
  }

  static func unfocus(from id: Int) {
    if let textField = container[id]?.object {
      textField.delegate?.textFieldDidEndEditing?(textField)
      textField.resignFirstResponder()
    }
  }

  func makeUIView(context: Context) -> UITextField {
    let textField = UITextField()
    textField.placeholder = placeholder
    textField.delegate = context.coordinator
    textField.addTarget(
      context.coordinator,
      action: #selector(Coordinator.textFieldDidChangeInput(_:)),
      for: .editingChanged
    )
    InputField.container[id] = WeakReference.to(textField)
    return textField
  }

  func updateUIView(_ textField: UITextField, context: Context) {
    textField.text = text
  }

  func makeCoordinator() -> Coordinator {
    return Coordinator(owner: self)
  }

  init(_ placeholder: String, id: Int, text: Binding<String>, isEditing: Binding<Bool>) {
    self.placeholder = placeholder
    self.id = id
    self._text = text
    self._isEditing = isEditing
  }

  // MARK: - Coordinator/Delegate

  final class Coordinator: NSObject, UITextFieldDelegate {
    let owner: InputField
    init(owner: InputField) {
      self.owner = owner
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
      owner.isEditing = true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
      owner.isEditing = false
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      textField.resignFirstResponder()
      // Focus on next text field
      if let nextResponder = InputField.container[owner.id + 1] {
        nextResponder.object?.becomeFirstResponder()
      }
      return true
    }
    @objc func textFieldDidChangeInput(_ textField: UITextField) {
      owner.text = textField.text ?? ""
    }
  }

}

// MARK: - Previews

private struct InputFieldAdjustedForPreview: View {
  @Binding var text: String
  var body: some View {
    InputField("Search", id: 0, text: $text, isEditing: .constant(false))
      .frame(width: 300, height: 14)
      .previewLayout(.sizeThatFits)
      .padding()
  }
}

struct InputField_Previews: PreviewProvider {
  static var previews: some View {
    InputFieldAdjustedForPreview(text: .constant("Search Field"))
    InputFieldAdjustedForPreview(text: .constant(""))
      .preferredColorScheme(.dark)
  }
}
