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

  public var trainCode: TrainCode {
    for code in TrainCode.sortedCases {
      // Works correctly because of sorting (longer values in the beginning)
      if name.lowercased().hasPrefix(code.rawValue) {
        return code
      }
    }
    return .other
  }

}

public enum TrainCode: String, CaseIterable {
  static let sortedCases = allCases.sorted { $0.rawValue > $1.rawValue }
  // Train Codes - from routes.txt
  case ic, r, s, rex, d, ec, cjx, rj, rjx, nj, en, cat, astb, ice, bus, os, sp, rb, dpn, er
  case other
}
