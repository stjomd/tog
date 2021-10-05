//
//  MockDataService.swift
//  tog
//
//  Created by Artem Zhukov on 13.08.21.
//

import Foundation
import Combine

class MockDataService {

  private var stops: [Stop] = []
  private var halts: [Halt] = []
  private var journeys: [Journey] = []

  private var favoriteDestinations: [FavoriteDestination] = []
  private var tickets: [Ticket] = []

  init(populate: Bool) {
    if populate { generate() }
  }

}

// MARK: - DataService Methods
extension MockDataService: DataService {

  // MARK: Fetchers

  func stops(by name: String) -> AnyPublisher<[Stop], Never> {
    let query = name.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
    let results = stops.filter {
      $0.name.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current).contains(query)
    }
    return Just(results).eraseToAnyPublisher()
  }

  func journeys(by query: JourneyQueryComponents?) -> AnyPublisher<[Journey], Never> {
    guard let query = query else {
      return Just([]).eraseToAnyPublisher()
    }
    let relevant = journeys.filter {
      $0.firstHalt.stop.id == query.origin.id && $0.lastHalt.stop.id == query.destination.id
    }
    let result = relevant.map { journey in
      Journey(legs: journey.legs, passengers: query.passengers, price: journey.price * query.passengers)
    }
    if let limit = query.limit {
      let trimmed: [Journey] = result.dropLast(max(0, result.count - limit))
      return Just(trimmed).eraseToAnyPublisher()
    } else {
      return Just(result).eraseToAnyPublisher()
    }
  }

  func favorites() -> AnyPublisher<[FavoriteDestination], Never> {
    Just(favoriteDestinations).eraseToAnyPublisher()
  }

  func tickets(_ selection: TicketSelection) -> AnyPublisher<[Ticket], Never> {
    switch selection {
    case .valid:
      return Just(tickets.filter { $0.isValid }).eraseToAnyPublisher()
    case .expired:
      return Just(tickets.filter { !$0.isValid }).eraseToAnyPublisher()
    case .all:
      return Just(tickets).eraseToAnyPublisher()
    }
  }

  // MARK: Posters

  func saveFavorite(_ favorite: FavoriteDestination) {
    if let existingIndex = favoriteDestinations.firstIndex(where: {
             $0.origin!.id == favorite.origin!.id && $0.destination!.id == favorite.destination!.id
           }) {
      favoriteDestinations[existingIndex].amount = favorite.amount
    } else {
      favoriteDestinations.append(favorite)
    }
  }

  func deleteFavorite(_ favorite: FavoriteDestination) {
    if let existingIndex = favoriteDestinations.firstIndex(where: {
             $0.origin!.id == favorite.origin!.id && $0.destination!.id == favorite.destination!.id
           }) {
      favoriteDestinations.remove(at: existingIndex)
    }
  }

  func buyTicket(_ ticket: Ticket) {
    tickets.append(ticket)
  }

}

// MARK: - MockableDataService Methods
extension MockDataService: MockableDataService {
  func mock(stops: [Stop]) {
    self.stops = stops
  }
}

// MARK: - Deserializing
private extension MockDataService {

  private func generate() {
    generateStops()
    generateHalts()
    generateJourneys()
  }

  private func generateStops() {
    stops += [
      Stop(id: 0, name: "Wien Hütteldorf Bahnhof", latitude: 40.0, longitude: 40.0),
      Stop(id: 1, name: "Wien Penzing Bahnhof", latitude: 40.1, longitude: 40.0),
      Stop(id: 2, name: "Wien Westbahnhof", latitude: 40.2, longitude: 40.0)
    ]
  }
  
  private func generateHalts() {
    // Hütteldorf -> Westbahnhof
    var dates = [TogApp.calendar.date(byAdding: .hour, value: 1, to: Date())!]
    dates.append(TogApp.calendar.date(byAdding: .minute, value: 1, to: dates.last!)!)
    dates.append(TogApp.calendar.date(byAdding: .minute, value: 6, to: dates.last!)!)
    dates.append(TogApp.calendar.date(byAdding: .minute, value: 1, to: dates.last!)!)
    dates.append(TogApp.calendar.date(byAdding: .minute, value: 4, to: dates.last!)!)
    dates.append(TogApp.calendar.date(byAdding: .minute, value: 1, to: dates.last!)!)
    halts += [
      Halt(id: 0, arrival: dates[0], departure: dates[1], stop: stops[0], stopSequence: 6),
      Halt(id: 1, arrival: dates[2], departure: dates[3], stop: stops[1], stopSequence: 7),
      Halt(id: 2, arrival: dates[4], departure: dates[5], stop: stops[2], stopSequence: 8)
    ]
    // Westbahnhof -> Hütteldorf
    dates = [TogApp.calendar.date(byAdding: .hour, value: 1, to: Date())!]
    dates.append(TogApp.calendar.date(byAdding: .minute, value: 1, to: dates.last!)!)
    dates.append(TogApp.calendar.date(byAdding: .minute, value: 4, to: dates.last!)!)
    dates.append(TogApp.calendar.date(byAdding: .minute, value: 1, to: dates.last!)!)
    dates.append(TogApp.calendar.date(byAdding: .minute, value: 6, to: dates.last!)!)
    dates.append(TogApp.calendar.date(byAdding: .minute, value: 1, to: dates.last!)!)
    halts += [
      Halt(id: 3, arrival: dates[0], departure: dates[1], stop: stops[2], stopSequence: 1),
      Halt(id: 4, arrival: dates[2], departure: dates[3], stop: stops[1], stopSequence: 2),
      Halt(id: 5, arrival: dates[4], departure: dates[5], stop: stops[0], stopSequence: 3)
    ]
  }
  
  private func generateJourneys() {
    journeys += [
      // Wien Hütteldorf -> Wien Westbahnhof
      Journey(
        legs: [
          JourneyLeg(
            halts: [halts[0], halts[1], halts[2]],
            trip: Trip(
              id: 0,
              headsign: "Wien Westbahnhof",
              shortName: nil,
              route: Route(id: 0, shortName: "S50")
            )
          )
        ],
        passengers: 1,
        price: 120
      ),
      Journey(
        legs: [
          JourneyLeg(
            halts: [halts[0], halts[1], halts[2]],
            trip: Trip(
              id: 1,
              headsign: "Wien Westbahnhof",
              shortName: nil,
              route: Route(id: 1, shortName: "R33")
            )
          )
        ],
        passengers: 1,
        price: 120
      ),
      // Wien Westbahnhof -> Wien Hütteldorf
      Journey(
        legs: [
          JourneyLeg(
            halts: [halts[3], halts[4], halts[5]],
            trip: Trip(
              id: 2,
              headsign: "St.Pölten Hbf",
              shortName: nil,
              route: Route(id: 2, shortName: "R33")
            )
          )
        ],
        passengers: 1,
        price: 120
      ),
      Journey(
        legs: [
          JourneyLeg(
            halts: [halts[3], halts[4], halts[5]],
            trip: Trip(
              id: 3,
              headsign: "Eichgraben-Altlengbach",
              shortName: nil,
              route: Route(id: 3, shortName: "S50")
            )
          )
        ],
        passengers: 1,
        price: 120
      )
    ]
  }

}
