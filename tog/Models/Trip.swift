//
//  Trip.swift
//  tog
//
//  Created by Artem Zhukov on 22.08.21.
//

import Foundation

public struct Trip: Codable, Hashable {
  public var id: Int
  public var headsign: String
  public var shortName: String?
  public var route: Route
}

extension Trip {
  public var name: String {
    shortName ?? route.shortName
  }
}
