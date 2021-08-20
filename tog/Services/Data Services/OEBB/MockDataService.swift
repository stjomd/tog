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

}

// MARK: - DataService Methods
// extension MockDataService: DataService {
//  func stops(by name: String) -> AnyPublisher<[Stop], Never> {
//
//  }
//
// }

// MARK: Deserializing
private extension MockDataService {

  private func deserialize() {
    loadStops()
    loadTrips()
    loadHalts() // requires: Stop, Trip // causes concurrency problems
  }

  private func openCSV(named name: String) -> CSV {
    guard let csv = try? CSV(url: unzippedURL.appendingPathComponent(name), loadColumns: false) else {
      fatalError("CSV Error")
    }
    return csv
  }

  // Stop
  private func loadStops() {
    let csv = openCSV(named: "stops.txt")
    for row in csv.enumeratedRows {
      if let id = Int(row[0]), let latitude = Double(row[4]), let longitude = Double(row[5]) {
        // Stop.create(withId: id, name: row[2], latitude: latitude, longitude: longitude, using: context)
      }
    }
  }

  // Trip
  private func loadTrips() {
    let csv = openCSV(named: "trips.txt")
    for row in csv.enumeratedRows {
      if let tripId = Int(row[2]) {
        let headsign = row[3]
        let shortName = (row[4] != "") ? row[4] : nil
        // Trip.create(withId: tripId, headsign: headsign, shortName: shortName, using: context)
      }
    }
  }

  // Halts
  private func loadHalts() {
    let csv = openCSV(named: "stop_times.txt")
    for row in csv.enumeratedRows {
      if let tripId = Int(row[0]), let stopId = Int(row[3]), let stopSequence = Int(row[4]),
         let arrival = Time(row[1]), let departure = Time(row[2]) {
        // let stop = self.stop(by: stopId)
        // let trip = self.trip(by: tripId)
        // Halt.create(at: stop, during: trip, arrival: arrival, departure: departure, sequence: stopSequence,
        //            using: context)
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
