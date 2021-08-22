//
//  Journey.swift
//  tog
//
//  Created by Artem Zhukov on 22.08.21.
//

import Foundation

public struct Journey: Codable, Hashable {
  public var legs: [JourneyLeg]
  public var price: Int
}

public struct JourneyLeg: Codable, Hashable {
  public var halts: [Halt]
  public var trip: Trip
}

extension Journey {
  public var departure: Time {
    legs.first!.halts.first!.departureTime
  }
  public var arrival: Time {
    legs.last!.halts.last!.arrivalTime
  }
}
