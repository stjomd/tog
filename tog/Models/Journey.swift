//
//  Journey.swift
//  tog
//
//  Created by Artem Zhukov on 11.08.21.
//

import Foundation

struct Journey: Hashable {
  let origin: String
  let destination: String
  let departure: Date
  let arrival: Date
  let train: String
}

extension Journey {
  static let s45 = Journey(origin: "Wien Penzing", destination: "Wien Heiligenstadt", departure: Date(), arrival: Date(), train: "S45")
  static let s50 = Journey(origin: "Wien Penzing", destination: "Wien Westbahnhof", departure: Date(), arrival: Date(), train: "S50")
  static let rex = Journey(origin: "Wien Penzing", destination: "Wien Westbahnhof", departure: Date(), arrival: Date(), train: "REX")
}
