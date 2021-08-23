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

  private let urlSession = URLSession.shared

  private let jsonDecoder: JSONDecoder = {
    let js = JSONDecoder()
    js.dateDecodingStrategy = .togServerDateStrategy
    return js
  }()

}

// MARK: - DataService Methods

extension TogDataService: DataService {

  func stops(by name: String) -> AnyPublisher<[Stop], Never> {
    let url = url(baseURL.appendingPathComponent("stops"), parameters: ["name": name])
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
    let url = url(
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

}

extension TogDataService {
  /// Appends query parameters to a URL.
  /// - parameters:
  ///   - url: The URL.
  ///   - parameters: A dictionary with query parameters.
  /// - returns: The `url` with appended query `parameters`. If `parameters` is nil, the original `url` is returned.
  private func url(_ url: URL, parameters: [String: String?]? = nil) -> URL {
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
