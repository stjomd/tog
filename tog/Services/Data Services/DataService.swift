//
//  DataService.swift
//  tog
//
//  Created by Artem Zhukov on 13.08.21.
//

import Foundation
import Combine

protocol DataService {

  // MARK: - Fetchers

  /// Fetches stops that match the given name.
  /// - parameter name: The name against which the search is to be performed.
  /// - returns: A publisher that emits an array of stops.
  func stops(by name: String) -> AnyPublisher<[Stop], Never>

  /// Fetches journeys between two stations at a specified time.
  /// - parameter query: A `JourneyQueryComponents` object that encapsulates the required parameters.
  /// - returns: A publisher that emits an array of journeys.
  func journeys(by query: JourneyQueryComponents?) -> AnyPublisher<[Journey], Never>

  /// Fetches favorite destinations.
  /// - returns: A publisher that emits an array of favorite destinations.
  func favorites() -> AnyPublisher<[FavoriteDestination], Never>

  // MARK: - Posters

  /// Saves a favorite destination.
  /// - parameter favorite: A favorite destination to be saved.
  func addFavorite(_ favorite: FavoriteDestination)

}

protocol MockableDataService: DataService {
  func mock(stops: [Stop])
}
