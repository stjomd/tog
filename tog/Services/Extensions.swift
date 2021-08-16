//
//  Extension.swift
//  tog
//
//  Created by Artem Zhukov on 15.08.21.
//

import Foundation

extension FileManager {
  static var documentsDirectoryURL: URL {
    Self.default.urls(for: .documentDirectory, in: .userDomainMask).first!
  }
}

@propertyWrapper
struct Autowired<T> {
  var wrappedValue: T? {
    TogApp.container.resolve(T.self)
  }
}
