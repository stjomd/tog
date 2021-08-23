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
  // `legs` is guaranteed to have at least one JourneyLeg;
  // `journeyLeg.halts` is guaranteed to have at least one halt.
  public var departure: Time {
    legs.first!.halts.first!.departureTime
  }
  public var arrival: Time {
    legs.last!.halts.last!.arrivalTime
  }
  public var priceString: String {
    String(format: "%.2f €", Double(price)/100)
  }
}

extension Journey {
  static let example = Journey(
    legs: [
      JourneyLeg(
        halts: [
          Halt(
            id: 0,
            arrival: Date(),
            departure: Date(),
            stop: Stop(id: 0, name: "Wien Penzing Bahnhof", latitude: 0, longitude: 0),
            stopSequence: 1
          ),
          Halt(
            id: 1,
            arrival: Date(),
            departure: Date(),
            stop: Stop(id: 1, name: "Wien Hütteldorf Bahnhof", latitude: 0, longitude: 0),
            stopSequence: 2
          )
        ],
        trip: Trip(
          id: 0,
          headsign: "Wien Westbahnof",
          shortName: nil,
          route: Route(id: 0, shortName: "CJX5")
        )
      )
    ],
    price: 3450
  )
}
