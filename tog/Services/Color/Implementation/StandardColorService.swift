//
//  StandardColorService.swift
//  tog
//
//  Created by Artem Zhukov on 13.08.21.
//

import Foundation
import SwiftUI

class StandardColorService: ColorService {

  /// A value used when reducing a string. Changing this value will affect the generated colors slightly.
  private let reductionBound = 131

  func components(from string: String) -> ColorComponents {
    let value = Double(reduce(string))
    let red   = sin(value) * sin(value)
    let green = 0.5 + sin(value) * cos(value)
    let blue  = cos(value) * cos(value)
    return ColorComponents(red: red, green: green, blue: blue)
  }

  func choose(bright: Color, dark: Color, against background: ColorComponents) -> Color {
    return background.contrastingColor(bright: bright, dark: dark)
  }

  func color(for code: TrainCode) -> Color {
    switch code {
    case .rex, .rjx, .r, .rj, .cjx:
      return Globals.Colors.Transport.rex
    case .s:
      return Globals.Colors.Transport.sBahn
    default:
      return Globals.Colors.Transport.other
    }
  }

  /// Reduces a string into an integer value.
  /// - parameter string: The string to be reduced.
  /// - returns: A positive integer value that is bound by (smaller than) `ColorService.reductionBound`.
  private func reduce(_ string: String) -> Int {
    var value = 0
    for char in string {
      value = (value + Int(char.asciiValue ?? 0)) % reductionBound
    }
    return value
  }

}
