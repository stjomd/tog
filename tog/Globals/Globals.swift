//
//  Globals.swift
//  tog
//
//  Created by Artem Zhukov on 11.08.21.
//

// swiftlint:disable nesting

import SwiftUI

enum Globals {

  /// The base URL of the server.
  static let baseURL: URL = {
    guard let string = Bundle.main.infoDictionary?["SERVER_URL"] as? String else {
      fatalError("Attempted to access server URL, which is not set in Info.plist.")
    }
    guard let url = URL(string: string) else {
      fatalError("Attempted to access server URL, but its value (\(string)) in Info.plist is invalid.")
    }
    return url
  }()

  enum Colors {
    enum Transport {
      static let sBahn = Color("SBahnColor")
      static let rex   = Color("REXColor")
      static let other = Color("OtherTransportColor")
    }
  }

  enum Icons {
    static let location = Image(systemName: "location.circle.fill")
    static let rightArrow = Image(systemName: "arrow.right")
    static let more = Image(systemName: "ellipsis.circle")
    static let clear = Image(systemName: "delete.left")
    static let swap = Image(systemName: "arrow.up.arrow.down")
    static let clock = Image(systemName: "timer")
    static let money = Image(systemName: "banknote")
    static let star = Image(systemName: "star")
    static let starFill = Image(systemName: "star.fill")
    static let train = Image(systemName: "tram.fill")
    static let arrivalArrow = Image(systemName: "arrow.down.to.line.compact")
    static let departureArrow = Image(systemName: "arrow.up")
  }

}
