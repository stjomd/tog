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
}
