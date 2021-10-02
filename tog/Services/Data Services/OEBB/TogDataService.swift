//
//  TogDataService.swift
//  tog
//
//  Created by Artem Zhukov on 19.08.21.
//

import Foundation
import Combine

class TogDataService {

  private let baseURL = Globals.baseURL
  private let favoritesURL = FileManager.documentsDirectoryURL.appendingPathComponent("favs.json")

  private let urlSession = URLSession.shared

  private let jsonDecoder: JSONDecoder = {
    let js = JSONDecoder()
    js.dateDecodingStrategy = .togServerDateStrategy
    return js
  }()
  private let jsonEncoder: JSONEncoder = {
    let js = JSONEncoder()
    js.outputFormatting = .prettyPrinted
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
    if FileManager.default.fileExists(atPath: favoritesURL.path) {
      return Just(rawFavorites()).eraseToAnyPublisher()
    } else {
      return Just([]).eraseToAnyPublisher()
    }
  }

  // MARK: Posters

  func saveFavorite(_ favorite: FavoriteDestination) {
    var newFavs = rawFavorites()
    if let indexOfOldFavorite = newFavs.firstIndex(where: { $0.id == favorite.id }) {
      newFavs[indexOfOldFavorite] = favorite
    } else {
      newFavs.append(favorite)
    }
    do {
      let data = try jsonEncoder.encode(newFavs)
      try data.write(to: favoritesURL)
    } catch let error {
      print(error)
    }
  }

  func deleteFavorite(_ favorite: FavoriteDestination) {
    var newFavs = rawFavorites()
    if let indexOfFavorite = newFavs.firstIndex(where: { $0.id == favorite.id }) {
      newFavs.remove(at: indexOfFavorite)
    }
    do {
      let data = try jsonEncoder.encode(newFavs)
      try data.write(to: favoritesURL)
    } catch let error {
      print(error)
    }
  }

  // MARK: Helpers

  private func rawFavorites() -> [FavoriteDestination] {
    if FileManager.default.fileExists(atPath: favoritesURL.path) {
      do {
        let data = try Data(contentsOf: favoritesURL)
        return try jsonDecoder.decode([FavoriteDestination].self, from: data)
      } catch let error {
        print(error)
      }
    }
    return []
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
