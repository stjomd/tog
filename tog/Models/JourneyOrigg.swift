//
//  JourneyOrigg.swift
//  tog
//
//  Created by Artem Zhukov on 11.08.21.
//

import Foundation

struct JourneyOrigg: Hashable {
  let origin: String
  let destination: String
  let departure: Date
  let arrival: Date
  let train: String
}

extension JourneyOrigg {
  static let s45 = JourneyOrigg(origin: "Wien Penzing", destination: "Wien Heiligenstadt", departure: Date(),
                           arrival: Date(), train: "S45")
  static let s50 = JourneyOrigg(origin: "Wien Penzing", destination: "Wien Westbahnhof", departure: Date(),
                           arrival: Date(), train: "S50")
  static let rex = JourneyOrigg(origin: "Wien Penzing", destination: "Wien Westbahnhof", departure: Date(),
                           arrival: Date(), train: "REX")
  static let cjx = JourneyOrigg(origin: "Wien Hütteldorf", destination: "Amstetten", departure: Date(),
                           arrival: Date(), train: "CJX")
}
