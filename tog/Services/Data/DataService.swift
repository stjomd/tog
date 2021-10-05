//
//  DataService.swift
//  tog
//
//  Created by Artem Zhukov on 13.08.21.
//

import Foundation
import Combine

enum TicketSelection {
  case valid, expired, all
}

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

  /// Fetches tickets.
  /// - parameter selection: An option that determines which tickets are to be fetched.
  /// - returns: A publisher that emits an array of chosen tickets.
  func tickets(_ selection: TicketSelection) -> AnyPublisher<[Ticket], Never>

  // MARK: - Posters

  /// Saves a favorite destination. If this favorite already exists, it will be updated.
  /// - parameter favorite: A favorite destination to be saved.
  func saveFavorite(_ favorite: FavoriteDestination)

  /// Deletes a favorite destination.
  /// - parameter favorite: A favorite destination to be deleted.
  func deleteFavorite(_ favorite: FavoriteDestination)

  /// Performs a purchase of a ticket.
  /// - parameter ticket: A ticket object to be persisted.
  func buyTicket(_ ticket: Ticket)

}

protocol MockableDataService: DataService {
  func mock(stops: [Stop])
}
