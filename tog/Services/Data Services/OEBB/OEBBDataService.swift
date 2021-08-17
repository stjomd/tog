//
//  OEBBDataService.swift
//  tog
//
//  Created by Artem Zhukov on 13.08.21.
//

import Foundation
import CoreData
import SwiftCSV
import Zip

class OEBBDataService {

  private let context: NSManagedObjectContext
  private let shouldPopulate: Bool

  private let zipURL = Bundle.main.url(forResource: "oebb-data", withExtension: "zip")
  private let unzippedURL = FileManager.documentsDirectoryURL.appendingPathComponent("oebb-data")

  init(context: NSManagedObjectContext, populate: Bool) {
    self.context = context
    self.shouldPopulate = populate
    if populate {
      DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        self?.downloadData()
        self?.setupDatabase()
      }
    }
  }

}

// MARK: - DataService Methods
extension OEBBDataService: DataService {
  public func stops(by name: String) -> [Stop] {
    let request: NSFetchRequest<Stop> = Stop.fetchRequest()
    request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", name)
    do {
      return try context.fetch(request) as [Stop]
    } catch {
      fatalError(error.localizedDescription)
    }
  }
  public func halts(at stop: Stop) -> [Halt] {
    let request: NSFetchRequest<Halt> = Halt.fetchRequest()
    request.predicate = NSPredicate(format: "stop.id == %@", NSNumber(value: stop.id))
    do {
      return try context.fetch(request) as [Halt]
    } catch {
      fatalError(error.localizedDescription)
    }
  }
}

// MARK: - Internal Fetchers
private extension OEBBDataService {
  private func stop(by id: Int) -> Stop {
    let request: NSFetchRequest<Stop> = Stop.fetchRequest()
    request.predicate = NSPredicate(format: "id == %@", NSNumber(value: id))
    do {
      return (try context.fetch(request) as [Stop])[0]
    } catch {
      fatalError(error.localizedDescription)
    }
  }
  private func trip(by id: Int) -> Trip {
    let request: NSFetchRequest<Trip> = Trip.fetchRequest()
    request.predicate = NSPredicate(format: "id == %@", NSNumber(value: id))
    do {
      return (try context.fetch(request) as [Trip])[0]
    } catch {
      fatalError(error.localizedDescription)
    }
  }
}

// MARK: - Database Population (mocks)
private extension OEBBDataService {
  private func setupDatabase() {
    clearDatabase()
    deserialize()
  }
  private func clearDatabase() {
    // Stops
    let fetchRequest: NSFetchRequest<Stop> = Stop.fetchRequest()
    do {
      // Cannot use batch request for compatibility with in-memory store (used in the tests)
      let contents = try context.fetch(fetchRequest) as [Stop]
      for object in contents {
        context.delete(object)
      }
      try context.save()
    } catch {
      fatalError("Couldn't clear stops")
    }
  }
}

// MARK: Deserializing
private extension OEBBDataService {

  private func deserialize() {
    loadStops()
    loadTrips()
    // loadHalts() // requires: Stop, Trip // causes concurrency problems
    do {
      try context.save()
    } catch {
      fatalError(error.localizedDescription)
    }
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
        Stop.create(withId: id, name: row[2], latitude: latitude, longitude: longitude, using: context)
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
        Trip.create(withId: tripId, headsign: headsign, shortName: shortName, using: context)
      }
    }
  }

  // Halts
  private func loadHalts() {
    let csv = openCSV(named: "stop_times.txt")
    for row in csv.enumeratedRows {
      if let tripId = Int(row[0]), let stopId = Int(row[3]), let stopSequence = Int(row[4]),
         let arrival = Time(row[1]), let departure = Time(row[2]) {
        let stop = self.stop(by: stopId)
        let trip = self.trip(by: tripId)
        Halt.create(at: stop, during: trip, arrival: arrival, departure: departure, sequence: stopSequence,
                    using: context)
      }
    }
  }

}

// MARK: - Data Download
private extension OEBBDataService {

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

  //  private let urlSession = URLSession.shared
  //  private let url = URL(string: "<#Link to ÖBB zip archive#>")!
  //  private func downloadData() {
  //    urlSession.downloadTask(with: url) { localURL, response, error in
  //      guard let localURL = localURL else {
  //        fatalError("No local URL")
  //      }
  //      let destination = FileManager.documentsDirectoryURL.appendingPathComponent("data.zip")
  //      // Delete previous download
  //      if FileManager.default.fileExists(atPath: destination.path) {
  //        do {
  //          try FileManager.default.removeItem(at: destination)
  //          print("Removed")
  //        } catch {
  //          fatalError("Remove error")
  //        }
  //      }
  //      // Write new version
  //      do {
  //        try FileManager.default.copyItem(at: localURL, to: destination)
  //        let _ = try Zip.quickUnzipFile(destination)
  //      } catch {
  //        fatalError("Move/unzip error: \(error)")
  //      }
  //    }.resume()
  //  }

}
