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
      print("xccss []")
      return Just([]).eraseToAnyPublisher()
    }
    var comps = URLComponents(string: Globals.baseURL.absoluteString + "/journeys")!
    comps.queryItems = [
      URLQueryItem(name: "originId", value: query.originId.description),
      URLQueryItem(name: "destinationId", value: query.destinationId.description),
      URLQueryItem(name: "date", value: query.date),
      URLQueryItem(name: "dateMode", value: query.dateMode),
      URLQueryItem(name: "passengers", value: query.passengers.description)
    ]
    return urlSession.dataTaskPublisher(for: comps.url!)
      .map(\.data)
      .decode(type: [Journey].self, decoder: jsonDecoder)
      .replaceError(with: [])
      .print()
      .eraseToAnyPublisher()
  }

}

extension JSONDecoder.DateDecodingStrategy {
  private static let togDateFormatter: DateFormatter = {
    let df = DateFormatter()
    df.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return df
  }()
  static let togServerDateStrategy = custom {
    let container = try $0.singleValueContainer()
    let string = try container.decode(String.self)
    if let date = togDateFormatter.date(from: string) {
      return date
    } else {
      throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date format: \(string)")
    }
//    do {
//      return try Date(timeIntervalSince1970: container.decode(Double.self))
//    } catch DecodingError.typeMismatch {
//      let string = try container.decode(String.self)
//      if let date = togDateFormatter.date(from: string) {
//        return date
//      } else {
//        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date format: \(string)")
//      }
//    }
  }
}
