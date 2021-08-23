//
//  Stop.swift
//  tog
//
//  Created by Artem Zhukov on 19.08.21.
//

import Foundation

public struct Stop: Codable, Hashable {
  public var id: Int
  public var name: String
  public var latitude: Double
  public var longitude: Double
}

extension Stop {
  static let penzing = Stop(id: 8100450, name: "Wien Penzing Bahnhof", latitude: 0, longitude: 0)
  static let westbahnhof = Stop(id: 8100003, name: "Wien Westbahnhof", latitude: 0, longitude: 0)
}
