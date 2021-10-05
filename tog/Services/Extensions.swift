//
//  Extension.swift
//  tog
//
//  Created by Artem Zhukov on 15.08.21.
//

import Foundation

// MARK: - DI annotation
@propertyWrapper
struct Autowired<T> {
  var wrappedValue: T? {
    TogApp.container.resolve(T.self)
  }
}

// MARK: - FileManager documents directory
extension FileManager {
  static var documentsDirectoryURL: URL {
    Self.default.urls(for: .documentDirectory, in: .userDomainMask).first!
  }
}

// MARK: - Date Formatters
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

// MARK: - JSON date coding strategies
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
  static let togServerDateStrategy = custom { date, encoder in
    var container = encoder.singleValueContainer()
    try container.encode(
      DateFormatter.longDateFormatter.string(from: date)
    )
  }
}

// MARK: - Date
extension Date {
  var timeString: String {
    let components = Calendar.current.dateComponents([.hour, .minute], from: self)
    let (hours, minutes) = (components.hour!, components.minute!)
    var (hstr, mstr) = ("", "")
    if hours < 10 { hstr += "0" }
    if minutes < 10 { mstr += "0" }
    hstr += hours.description; mstr += minutes.description
    return "\(hstr):\(mstr)"
  }
}
