//
//  Extension.swift
//  tog
//
//  Created by Artem Zhukov on 15.08.21.
//

import Foundation

@propertyWrapper
struct Autowired<T> {
  var wrappedValue: T? {
    TogApp.container.resolve(T.self)
  }
}

extension FileManager {
  static var documentsDirectoryURL: URL {
    Self.default.urls(for: .documentDirectory, in: .userDomainMask).first!
  }
}

extension DateFormatter {
  static let shortDateFormatter: DateFormatter = {
    let df = DateFormatter()
    df.dateFormat = "HH:mm:ss"
    return df
  }()
  static let longDateFormatter: DateFormatter = {
    let df = DateFormatter()
    df.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return df
  }()
}

extension JSONDecoder.DateDecodingStrategy {
  static let togServerDateStrategy = custom {
    let container = try $0.singleValueContainer()
    let string = try container.decode(String.self)
    if let date = DateFormatter.longDateFormatter.date(from: string) {
      return date
    } else {
      throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date format: \(string)")
    }
  }
}

extension JSONEncoder.DateEncodingStrategy {
  static let ticketDateStrategy = custom { date, encoder in
    var container = encoder.singleValueContainer()
    try container.encode(
      DateFormatter.longDateFormatter.string(from: date)
    )
//    if let date = DateFormatter.shortDateFormatter.date(from: string) {
//      return date
//    } else {
//      throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date format: \(string)")
//    }
  }
}
