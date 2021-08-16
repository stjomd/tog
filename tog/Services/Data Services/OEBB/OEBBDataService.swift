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
}


// MARK: - Database Population (mocks)
extension OEBBDataService {
  private func setupDatabase() {
    clearDatabase()
    loadStops()
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
extension OEBBDataService {
  private func loadStops() {
    guard let csv = try? CSV(url: unzippedURL.appendingPathComponent("stops.txt"), loadColumns: false) else {
      fatalError("CSV Error")
    }
    for row in csv.enumeratedRows {
      if let id = Int(row[0]), let latitude = Double(row[4]), let longitude = Double(row[5]) {
        Stop.createWith(id: id, name: row[2], latitude: latitude, longitude: longitude, using: context)
      }
    }
    do {
      try context.save()
    } catch {
      fatalError(error.localizedDescription)
    }
  }
}


// MARK: - Data Download
extension OEBBDataService {
  
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
  //  private let url = URL(string: "https://data.oebb.at/oebb?dataset=uddi:cd36722f-1b9a-11e8-8087-b71b4f81793a&file=uddi:d3e25791-7889-11e8-8fc8-edb0b0e1f0ef/GFTS_Fahrplan_OEBB.zip")!
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
