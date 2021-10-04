//
//  Ticket.swift
//  tog
//
//  Created by Artem Zhukov on 04.10.21.
//

import Foundation

public class Ticket: Codable {

  public var id: UUID
  public var journey: Journey
  public var expiration: Date
  public var passengers: Int

  init(journey: Journey, expiration: Date, passengers: Int) {
    self.id = UUID()
    self.journey = journey
    self.expiration = expiration
    self.passengers = passengers
  }

}

extension Ticket {

  private static var dateFormatter: DateFormatter = {
    let df = DateFormatter()
    df.dateFormat = "dd MMM"
    return df
  }()
  private static var timeFormatter: DateFormatter = {
    let df = DateFormatter()
    df.dateFormat = "HH:mm"
    return df
  }()

  public var expirationString: String {
    var string = ""
    if TogApp.calendar.isDateInYesterday(expiration) {
      string += "yesterday "
    } else if TogApp.calendar.isDateInToday(expiration) {
      string += "today "
    } else if TogApp.calendar.isDateInTomorrow(expiration) {
      string += "tomorrow "
    } else {
      string += Self.dateFormatter.string(from: expiration) + " "
    }
    string += Self.timeFormatter.string(from: expiration)
    return string
  }

  public var isValid: Bool {
    Date() <= expiration
  }

}

extension Ticket {
  static let valid = Ticket(
    journey: .example,
    expiration: TogApp.calendar.date(byAdding: .day, value: 3, to: Date())!,
    passengers: 1
  )
  static let expired = Ticket(
    journey: .example,
    expiration: TogApp.calendar.date(byAdding: .hour, value: -2, to: Date())!,
    passengers: 2
  )
}
