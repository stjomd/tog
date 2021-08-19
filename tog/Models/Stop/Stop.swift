//
//  Stop.swift
//  tog
//
//  Created by Artem Zhukov on 19.08.21.
//

import Foundation

public struct Stop: Codable {
  public var id: Int
  public var latitude: Double
  public var longitude: Double
  public var name: String
  // public var halts: Set<Halt>
}
