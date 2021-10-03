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
  /// Calculates the transfer time from a given leg to the next.
  /// - parameter leg: the journey leg from which transfer is performed.
  /// - returns: the time required to transfer, or `nil` if the next leg does not exist.
  public func transferTime(after leg: JourneyLeg) -> Time? {
    for i in self.legs.indices {
      if self.legs[i].trip.id == leg.trip.id {
        if i + 1 < self.legs.count {
          let nextLeg = self.legs[i + 1]
          return leg.halts.last!.arrivalTime.duration(to: nextLeg.halts.first!.departureTime)
        } else {
          return nil
        }
      }
    }
    return nil
  }
}

extension Journey {
  static let example = Journey(
    legs: [
      JourneyLeg(
        halts: [
          Halt(
            id: 50,
            arrival: Date(),
            departure: Date(),
            stop: Stop(id: 50, name: "Wien Meidling", latitude: 0, longitude: 0),
            stopSequence: 0
          ),
          Halt(
            id: 0,
            arrival: Date(),
            departure: Date(),
            stop: Stop(id: 0, name: "Wien Westbahnhof", latitude: 0, longitude: 0),
            stopSequence: 1
          ),
          Halt(
            id: 1,
            arrival: Date(),
            departure: Date(),
            stop: Stop(id: 1, name: "Wien Penzing Bahnhof", latitude: 0, longitude: 0),
            stopSequence: 2
          ),
          Halt(
            id: 2,
            arrival: Date(),
            departure: Date(),
            stop: Stop(id: 2, name: "Wien Hütteldorf Bahnhof", latitude: 0, longitude: 0),
            stopSequence: 3
          )
        ],
        trip: Trip(
          id: 0,
          headsign: "Neulengbach",
          shortName: nil,
          route: Route(id: 0, shortName: "S50")
        )
      ),
      JourneyLeg(
        halts: [
          Halt(
            id: 0,
            arrival: Date(),
            departure: Date(),
            stop: Stop(id: 2, name: "Wien Hütteldorf", latitude: 0, longitude: 0),
            stopSequence: 1
          ),
          Halt(
            id: 1,
            arrival: Date(),
            departure: Date(),
            stop: Stop(id: 10, name: "Tullnerfeld Bahnhof", latitude: 0, longitude: 0),
            stopSequence: 2
          ),
          Halt(
            id: 2,
            arrival: Date(),
            departure: Date(),
            stop: Stop(id: 11, name: "St. Pölten Hbf", latitude: 0, longitude: 0),
            stopSequence: 3
          )
        ],
        trip: Trip(
          id: 1,
          headsign: "St. Valentin Bahnhof",
          shortName: nil,
          route: Route(id: 1, shortName: "CJX5")
        )
      ),
      JourneyLeg(
        halts: [
          Halt(
            id: 0,
            arrival: Date(),
            departure: Date(),
            stop: Stop(id: 79, name: "St. Pölten Hbf", latitude: 0, longitude: 0),
            stopSequence: 0
          ),
          Halt(
            id: 1,
            arrival: Date(),
            departure: Date(),
            stop: Stop(id: 78, name: "Prinzersdorf", latitude: 0, longitude: 0),
            stopSequence: 1
          )
        ],
        trip: Trip(
          id: 13,
          headsign: "Pöchlarn",
          shortName: nil,
          route: Route(id: 67, shortName: "R52")
        )
      )
    ],
    price: 3450
  )
}
