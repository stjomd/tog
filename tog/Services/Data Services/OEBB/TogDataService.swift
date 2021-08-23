//
//  TogDataService.swift
//  tog
//
//  Created by Artem Zhukov on 19.08.21.
//

import Foundation
import Combine

class TogDataService {

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
    var comps = URLComponents(string: Globals.baseURL.absoluteString + "/stops")!
    comps.queryItems = [URLQueryItem(name: "name", value: name)]
    return urlSession.dataTaskPublisher(for: comps.url!)
      .map(\.data)
      .decode(type: [Stop].self, decoder: JSONDecoder())
      .replaceError(with: [])
      .eraseToAnyPublisher()
  }

  func journeys(by query: JourneyQueryComponents?) -> AnyPublisher<[Journey], Never> {
    guard let query = query else {
      return Just([]).eraseToAnyPublisher()
    }
    var comps = URLComponents(string: Globals.baseURL.absoluteString + "/journeys")!
    comps.queryItems = [
      URLQueryItem(name: "originId", value: query.origin.id.description),
      URLQueryItem(name: "destinationId", value: query.destination.id.description),
      URLQueryItem(name: "date", value: DateFormatter.longDateFormatter.string(from: query.date)),
      URLQueryItem(name: "dateMode", value: query.dateMode.description.uppercased()),
      URLQueryItem(name: "passengers", value: query.passengers.description)
    ]
    return urlSession.dataTaskPublisher(for: comps.url!)
      .map(\.data)
      .decode(type: [Journey].self, decoder: jsonDecoder)
      .replaceError(with: [])
      .eraseToAnyPublisher()
  }

}
