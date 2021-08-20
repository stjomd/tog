//
//  MockDataService.swift
//  tog
//
//  Created by Artem Zhukov on 13.08.21.
//

import Foundation
import Combine
import SwiftCSV
import Zip

class MockDataService {

  private let zipURL = Bundle.main.url(forResource: "oebb-data", withExtension: "zip")
  private let unzippedURL = FileManager.documentsDirectoryURL.appendingPathComponent("oebb-data")

  private var stops: [Stop] = []

  init() {
    deserialize()
  }

}

// MARK: - DataService Methods
 extension MockDataService: DataService {
  func stops(by name: String) -> AnyPublisher<[Stop], Never> {
    let query = name.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
    let results = stops.filter {
      $0.name.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current).contains(query)
    }
    return Just(results).eraseToAnyPublisher()
  }
 }

// MARK: - Deserializing
private extension MockDataService {

  private func deserialize() {
    loadStops()
  }

  private func openCSV(named name: String) -> CSV {
    guard let csv = try? CSV(url: unzippedURL.appendingPathComponent(name), loadColumns: false) else {
      fatalError("CSV Error")
    }
    return csv
  }

  // Stops
  private func loadStops() {
    let csv = openCSV(named: "stops.txt")
    for row in csv.enumeratedRows {
      if let id = Int(row[0]), let latitude = Double(row[4]), let longitude = Double(row[5]) {
        let stop = Stop(id: id, latitude: latitude, longitude: longitude, name: row[2])
        stops.append(stop)
      }
    }
  }

}

// MARK: - Data Download
private extension MockDataService {
  // Download from the ÖBB's url results in a corrupted zip file that cannot be unpacked...
  // Therefore the data is loaded from the bundle :(
  private func downloadData() {
    guard let url = zipURL else {
      fatalError("No URL for data")
    }
    do {
      try Zip.unzipFile(url, destination: unzippedURL, overwrite: true, password: nil)
    } catch {
      fatalError("Couldn't unzip \(error.localizedDescription)")
    }
  }
}
