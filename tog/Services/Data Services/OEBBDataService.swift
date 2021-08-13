//
//  OEBBDataService.swift
//  tog
//
//  Created by Artem Zhukov on 13.08.21.
//

import Foundation

class OEBBDataService: DataService {
  
  private let urlSession = URLSession.shared
  private let url = URL(string: "https://data.oebb.at/oebb?dataset=uddi:cd36722f-1b9a-11e8-8087-b71b4f81793a&file=uddi:d3e25791-7889-11e8-8fc8-edb0b0e1f0ef/GFTS_Fahrplan_OEBB.zip")!
  
  override init() {
    super.init()
    downloadData()
  }
  
  private func downloadData() {
    urlSession.downloadTask(with: url) { localURL, response, error in
      guard let localURL = localURL else {
        fatalError("No local URL")
      }
      let destination = FileManager.documentsDirectoryURL.appendingPathComponent("data.zip")
      // Delete previous download
      if FileManager.default.fileExists(atPath: destination.path) {
        do {
          try FileManager.default.removeItem(at: destination)
        } catch {
          fatalError("Remove error")
        }
      }
      // Write new version
      do {
        try FileManager.default.copyItem(at: localURL, to: destination)
      } catch {
        fatalError("Move error")
      }
    }.resume()
  }
  
}
