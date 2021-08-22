//
//  Journey.swift
//  tog
//
//  Created by Artem Zhukov on 22.08.21.
//

import Foundation

public struct Journey: Codable {
  public var legs: [JourneyLeg]
  public var price: Int
}

public struct JourneyLeg: Codable {
  public var halts: [Halt]
  public var trip: Trip
}
