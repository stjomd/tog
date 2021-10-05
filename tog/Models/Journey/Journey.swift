//
//  Journey.swift
//  tog
//
//  Created by Artem Zhukov on 22.08.21.
//

import Foundation

public struct Journey: Codable, Hashable {
  public var legs: [JourneyLeg]
  public var passengers: Int
  public var price: Int
}

public struct JourneyLeg: Codable, Hashable {
  public var halts: [Halt]
  public var trip: Trip
}

extension Journey {
  // `legs` is guaranteed to have at least one JourneyLeg;
  // `journeyLeg.halts` is guaranteed to have at least one halt.
  public var firstHalt: Halt {
    legs.first!.halts.first!
  }
  public var lastHalt: Halt {
    legs.last!.halts.last!
  }
  public var departure: Date {
    firstHalt.departure
  }
  public var arrival: Date {
    lastHalt.arrival
  }
  public var priceString: String {
    String(format: "%.2f €", Double(price)/100)
  }
  public var durationString: String {
    let (hours, minutes) = self.duration(from: self.departure, to: self.arrival)
    if hours == 0 {
      return "\(minutes)m"
    } else {
      return "\(hours)h \(minutes)m"
    }
  }
  /// Calculates the transfer time from a given leg to the next.
  /// - parameter leg: the journey leg from which transfer is performed.
  /// - returns: the time required to transfer, or `nil` if the next leg does not exist.
  public func transferTimeString(after leg: JourneyLeg) -> String? {
    for i in self.legs.indices {
      if self.legs[i].trip.id == leg.trip.id {
        if i + 1 < self.legs.count {
          let nextLeg = self.legs[i + 1]
          let (hours, minutes) = self.duration(from: leg.halts.last!.arrival, to: nextLeg.halts.first!.departure)
          if hours == 0 {
            return "\(minutes)m"
          } else {
            return "\(hours)h \(minutes)m"
          }
        } else {
          return nil
        }
      }
    }
    return nil
  }
  private func duration(from: Date, to: Date) -> (hours: Int, minutes: Int) {
    let components = Calendar.current.dateComponents(
      [.hour, .minute], from: self.departure, to: self.arrival
    )
    return (hours: components.hour!, minutes: components.minute!)
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
            stop: Stop(id: 50, name: "Wien Meidling Bahnhof", latitude: 48.174582, longitude: 16.333737),
            stopSequence: 0
          ),
          Halt(
            id: 0,
            arrival: Date(),
            departure: Date(),
            stop: Stop(id: 0, name: "Wien Westbahnhof", latitude: 48.196753, longitude: 16.337255),
            stopSequence: 1
          ),
          Halt(
            id: 1,
            arrival: Date(),
            departure: Date(),
            stop: Stop(id: 1, name: "Wien Penzing Bahnhof", latitude: 48.192694, longitude: 16.30486),
            stopSequence: 2
          ),
          Halt(
            id: 2,
            arrival: Date(),
            departure: Date(),
            stop: Stop(id: 2, name: "Wien Hütteldorf Bahnhof", latitude: 48.197354, longitude: 16.261117),
            stopSequence: 3
          )
        ],
        trip: Trip(
          id: 0,
          headsign: "Neulengbach Bahnhof",
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
            stop: Stop(id: 2, name: "Wien Hütteldorf Bahnhof", latitude: 48.197354, longitude: 16.261117),
            stopSequence: 1
          ),
          Halt(
            id: 1,
            arrival: Date(),
            departure: Date(),
            stop: Stop(id: 10, name: "Tullnerfeld Bahnhof", latitude: 48.295274, longitude: 15.996528),
            stopSequence: 2
          ),
          Halt(
            id: 2,
            arrival: Date(),
            departure: Date(),
            stop: Stop(id: 11, name: "St. Pölten Hbf", latitude: 48.208332, longitude: 15.623804),
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
            stop: Stop(id: 79, name: "St. Pölten Hbf", latitude: 48.208332, longitude: 15.623804),
            stopSequence: 0
          ),
          Halt(
            id: 1,
            arrival: Date(),
            departure: Date(),
            stop: Stop(id: 78, name: "Prinzersdorf Bahnhof", latitude: 48.203095, longitude: 15.526097),
            stopSequence: 1
          )
        ],
        trip: Trip(
          id: 13,
          headsign: "Pöchlarn Bahnhof",
          shortName: nil,
          route: Route(id: 67, shortName: "R52")
        )
      )
    ],
    passengers: 1,
    price: 3450
  )
}
