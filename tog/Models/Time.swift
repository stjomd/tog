//
//  Time.swift
//  tog
//
//  Created by Artem Zhukov on 17.08.21.
//

import Foundation

public struct Time {

  let hours: Int
  let minutes: Int
  let seconds: Int

  init?(hours: Int, minutes: Int, seconds: Int) {
    guard hours < 24 && minutes < 60 && seconds < 60,
          hours >= 0 && minutes >= 0 && seconds >= 0 else {
      return nil
    }
    self.hours = hours
    self.minutes = minutes
    self.seconds = seconds
  }

  init?(_ string: String) {
    let components = string.split(separator: ":")
    // Guarantee two components: 11:59
    guard components.count >= 2, let hours = Int(components[0]), let minutes = Int(components[1]) else {
      return nil
    }
    // Check if three components: 11:59:59
    var seconds = 0
    if components.count == 3, let parsedSeconds = Int(components[2]) {
      seconds = parsedSeconds
    } else if components.count > 3 {
      return nil
    }
    // Initialize
    self.init(hours: hours, minutes: minutes, seconds: seconds)
  }

}

extension Time: CustomStringConvertible {
  public var description: String {
    var string = ""
    if hours < 10 {
      string += "0"
    }
    string += hours.description + ":"
    if minutes < 10 {
      string += "0"
    }
    string += minutes.description + ":"
    if seconds < 10 {
      string += "0"
    }
    string += seconds.description
    return string
  }
}
