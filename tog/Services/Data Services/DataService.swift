//
//  DataService.swift
//  tog
//
//  Created by Artem Zhukov on 13.08.21.
//

import Foundation

protocol DataService {
  
  /// Fetches stops from the database that match the given name.
  /// - parameter name: The name against which the search is to be performed.
  /// - returns: An array of stops that match.
  func fetchStops(by name: String) -> [Stop]
  
}
