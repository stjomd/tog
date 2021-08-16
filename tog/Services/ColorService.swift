//
//  ColorService.swift
//  tog
//
//  Created by Artem Zhukov on 13.08.21.
//

import SwiftUI

/// A structure that encapsulates the red, green and blue values of a color.
struct ColorComponents {

  let red: Double
  let green: Double
  let blue: Double

  /// A SwiftUI Color that is represented by these color components.
  var color: Color {
    Color(red: red, green: green, blue: blue)
  }

  /// Decides if this color is dark or bright and chooses a color that is supposed to be more contrast against this color.
  /// - parameters:
  ///   - bright: The color to be selected against a dark background.
  ///   - dark: The color to be selected against a bright background.
  /// - returns: Either `bright` or `dark`, depending on whether `self` represents a dark or a bright background.
  func contrastingColor(bright: Color, dark: Color) -> Color {
    if 0.299*red + 0.587*green + 0.114*blue > 166/255 {
      return dark
    } else {
      return bright
    }
  }

}

class ColorService {

  /// A value used when reducing a string. Changing this value will affect the generated colors slightly.
  private let reductionBound = 131

  /// Generates color components from a string.
  /// - parameter string: The string to be converted.
  /// - returns: The generated color components, which contain the red, green and blue values.
  func components(from string: String) -> ColorComponents {
    let value = Double(reduce(string))
    let red   = sin(value) * sin(value)
    let green = 0.5 + sin(value) * cos(value)
    let blue  = cos(value) * cos(value)
    return ColorComponents(red: red, green: green, blue: blue)
  }

  /// Chooses a `bright` or `dark` color against a dark or bright background, respectively.
  /// - parameters:
  ///   - bright: The color to be selected against a dark background.
  ///   - dark: The color to be selected against a bright background.
  ///   - background: The color components that represent the background color.
  /// - returns: Either `bright` or `dark`, depending on whether `background` represents a dark or a bright background.
  func choose(bright: Color, dark: Color, against background: ColorComponents) -> Color {
    return background.contrastingColor(bright: bright, dark: dark)
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
