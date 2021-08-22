//
//  Halt.swift
//  tog
//
//  Created by Artem Zhukov on 22.08.21.
//

import Foundation

public struct Halt: Codable, Hashable {
  public  var id: Int
  private var arrival: Date
  private var departure: Date
  public  var stop: Stop
  public  var stopSequence: Int
  init(id: Int, arrival: Date, departure: Date, stop: Stop, stopSequence: Int) {
    self.id = id
    self.arrival = arrival
    self.departure = departure
    self.stop = stop
    self.stopSequence = stopSequence
  }
}

extension Halt {
  public var arrivalTime: Time {
    let hours   = TogApp.calendar.component(.hour, from: arrival)
    let minutes = TogApp.calendar.component(.minute, from: arrival)
    let seconds = TogApp.calendar.component(.second, from: arrival)
    return Time(hours: hours, minutes: minutes, seconds: seconds)!
  }
  public var departureTime: Time {
    let hours   = TogApp.calendar.component(.hour, from: departure)
    let minutes = TogApp.calendar.component(.minute, from: departure)
    let seconds = TogApp.calendar.component(.second, from: departure)
    return Time(hours: hours, minutes: minutes, seconds: seconds)!
  }
}
