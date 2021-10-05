//
//  Stop.swift
//  tog
//
//  Created by Artem Zhukov on 19.08.21.
//

import Foundation

public class Stop: Codable {

  public var id: Int

  public var name: String

  public var latitude: Double

  public var longitude: Double

  init(id: Int, name: String, latitude: Double, longitude: Double) {
    self.id = id
    self.name = name
    self.latitude = latitude
    self.longitude = longitude
  }

}

extension Stop: Equatable, Hashable {
  public static func == (lhs: Stop, rhs: Stop) -> Bool {
    lhs.id == rhs.id
  }
  public func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}

extension Stop {
  static let penzing = Stop(id: 8100450, name: "Wien Penzing Bahnhof", latitude: 0, longitude: 0)
  static let westbahnhof = Stop(id: 8100003, name: "Wien Westbahnhof", latitude: 0, longitude: 0)
}
