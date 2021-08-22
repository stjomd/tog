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

  public var shortDescription: String {
    var string = ""
    if hours < 10 {
      string += "0"
    }
    string += hours.description + ":"
    if minutes < 10 {
      string += "0"
    }
    string += minutes.description
    return string
  }

  public var description: String {
    var string = shortDescription + ":"
    if seconds < 10 {
      string += "0"
    }
    string += seconds.description
    return string
  }

  public var textualDescription: String {
    String(format: "%dh %dm", self.hours, self.minutes)
  }

}

extension Time {
  func duration(to time: Time) -> Time {
    let selfSeconds = 60*60*self.hours + 60*self.minutes + self.seconds
    let destSeconds = 60*60*time.hours + 60*time.minutes + time.seconds
    var difference = abs(selfSeconds - destSeconds) % (24 * 3600)
    let hours   = difference / 3600
    difference %= 3600
    let minutes = difference / 60
    let seconds = difference % 60
    return Time(hours: hours, minutes: minutes, seconds: seconds)!
  }
}
