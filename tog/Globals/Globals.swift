//
//  Globals.swift
//  tog
//
//  Created by Artem Zhukov on 11.08.21.
//

// swiftlint:disable nesting

import SwiftUI

enum Globals {

  /// The base URL of the server. Should be set as an environment variable `SERVER_URL`.
  static let baseURL = URL(string: ProcessInfo.processInfo.environment["SERVER_URL"]!)!

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
  }

}
