//
//  Stop.swift
//  tog
//
//  Created by Artem Zhukov on 19.08.21.
//

import Foundation
import RealmSwift

public class Stop: Object, Codable {

  @Persisted(primaryKey: true)
  public var id: Int

  @Persisted
  public var name: String

  @Persisted
  public var latitude: Double

  @Persisted
  public var longitude: Double

  convenience init(id: Int, name: String, latitude: Double, longitude: Double) {
    self.init()
    self.id = id
    self.name = name
    self.latitude = latitude
    self.longitude = longitude
  }

}

extension Stop {
  static let penzing = Stop(id: 8100450, name: "Wien Penzing Bahnhof", latitude: 0, longitude: 0)
  static let westbahnhof = Stop(id: 8100003, name: "Wien Westbahnhof", latitude: 0, longitude: 0)
}
