//
//  Trip.swift
//  tog
//
//  Created by Artem Zhukov on 22.08.21.
//

import Foundation

public struct Trip: Codable {
  public var id: Int
  public var headsign: String
  public var shortName: String?
}
