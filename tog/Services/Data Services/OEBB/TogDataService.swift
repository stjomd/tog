//
//  TogDataService.swift
//  tog
//
//  Created by Artem Zhukov on 19.08.21.
//

import Foundation
import CoreData

class TogDataService {
  private let urlSession = URLSession.shared
}

// MARK: - DataService Methods

extension TogDataService: DataService {
  func stops(by name: String) -> [Stop] {
    return []
  }
}
