//
//  Globals.swift
//  tog
//
//  Created by Artem Zhukov on 11.08.21.
//

import SwiftUI

enum Globals {

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
  }

}
