//
//  DataService.swift
//  tog
//
//  Created by Artem Zhukov on 13.08.21.
//

import Foundation
import Combine

protocol DataService {

  /// Fetches stops from the database that match the given name.
  /// - parameter name: The name against which the search is to be performed.
  /// - returns: A publisher that holds an array of stops.
  func stops(by name: String) -> AnyPublisher<[Stop], Never>

  func journeys(by query: JourneyQueryComponents?) -> AnyPublisher<[Journey], Never>

}

protocol MockableDataService: DataService {
  func mock(stops: [Stop])
}
