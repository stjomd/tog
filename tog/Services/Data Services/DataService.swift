//
//  DataService.swift
//  tog
//
//  Created by Artem Zhukov on 13.08.21.
//

import Foundation

// TODO: should be a protocol, not possible due to compiler limitations (environment object not allowed to be a protocol type)
class DataService: ObservableObject {
}

extension FileManager {
  static var documentsDirectoryURL: URL {
    Self.default.urls(for: .documentDirectory, in: .userDomainMask).first!
  }
}
