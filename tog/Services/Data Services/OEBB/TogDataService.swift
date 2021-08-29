//
//  TogDataService.swift
//  tog
//
//  Created by Artem Zhukov on 19.08.21.
//

import Foundation
import RealmSwift
import Combine

class TogDataService {

  @Autowired private var realm: Realm!

  private let baseURL = Globals.baseURL

  private let urlSession = URLSession.shared

  private let jsonDecoder: JSONDecoder = {
    let js = JSONDecoder()
    js.dateDecodingStrategy = .togServerDateStrategy
    return js
  }()

}

// MARK: - DataService Methods

extension TogDataService: DataService {

  // MARK: Fetchers

  func stops(by name: String) -> AnyPublisher<[Stop], Never> {
    let url = urlOf(baseURL.appendingPathComponent("stops"), parameters: ["name": name])
    return urlSession.dataTaskPublisher(for: url)
      .map(\.data)
      .decode(type: [Stop].self, decoder: jsonDecoder)
      .replaceError(with: [])
      .eraseToAnyPublisher()
  }

  func journeys(by query: JourneyQueryComponents?) -> AnyPublisher<[Journey], Never> {
    guard let query = query else {
      return Just([]).eraseToAnyPublisher()
    }
    let url = urlOf(
      baseURL.appendingPathComponent("journeys"),
      parameters: [
        "originId": query.origin.id.description,
        "destinationId": query.destination.id.description,
        "date": DateFormatter.longDateFormatter.string(from: query.date),
        "dateMode": query.dateMode.description.uppercased(),
        "passengers": query.passengers.description,
        "limit": query.limit?.description
      ]
    )
    return urlSession.dataTaskPublisher(for: url)
      .map(\.data)
      .decode(type: [Journey].self, decoder: jsonDecoder)
      .replaceError(with: [])
      .eraseToAnyPublisher()
  }

  func favorites() -> AnyPublisher<[FavoriteDestination], Never> {
    let favorites = realm.objects(FavoriteDestination.self)
    return Just(favorites)
      .map { Array($0) }
      .eraseToAnyPublisher()
  }

  // MARK: Posters

  func addFavorite(_ favorite: FavoriteDestination) {
    do {
      let origin      = realm.object(ofType: Stop.self, forPrimaryKey: favorite.origin!.id)
                        ?? favorite.origin!
      let destination = realm.object(ofType: Stop.self, forPrimaryKey: favorite.destination!.id)
                        ?? favorite.destination!
      favorite.origin = origin
      favorite.destination = destination
      try realm.write {
        realm.add(favorite)
      }
    } catch {
      return
    }
  }

  func deleteFavorite(_ favorite: FavoriteDestination) {
    do {
      // If no other favorites link to the stops, should delete the stops as well
      let favs = realm.objects(FavoriteDestination.self)
      let (deleteOrigin, deleteDestination) = (
        favs.filter("origin.id == %@", favorite.origin!.id).count <= 1,
        favs.filter("destination.id == %@", favorite.destination!.id).count <= 1
      )
      // Delete
      try realm.write {
        realm.delete(favorite)
        if deleteOrigin {
          realm.delete(favorite.origin!)
        }
        if deleteDestination {
          realm.delete(favorite.destination!)
        }
      }
    } catch {
      return
    }
  }

}

extension TogDataService {
  /// Appends query parameters to a URL.
  /// - parameters:
  ///   - url: The URL.
  ///   - parameters: A dictionary with query parameters.
  /// - returns: The `url` with appended query `parameters`. If `parameters` is nil, the original `url` is returned.
  private func urlOf(_ url: URL, parameters: [String: String?]? = nil) -> URL {
    guard let parameters = parameters else {
      return url
    }
    var components = URLComponents(string: url.absoluteString)!
    if !parameters.isEmpty {
      components.queryItems = []
      for (name, value) in parameters where value != nil {
        components.queryItems!.append(
          URLQueryItem(name: name, value: value)
        )
      }
    }
    return components.url!
  }
}
