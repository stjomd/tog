//
//  JourneyQuery.swift
//  tog
//
//  Created by Artem Zhukov on 22.08.21.
//

import Foundation
import Combine

class JourneyQuery: ObservableObject {

  fileprivate static let dateFormatter: DateFormatter = {
    let df = DateFormatter()
    df.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return df
  }()

  // MARK: - Properties

  @Autowired private var dataService: DataService!

  @Published var query: JourneyQueryComponents?
  @Published var results: [Journey] = []
  private var subscriptions: Set<AnyCancellable> = []

  init() {
    $query
      .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
      .flatMap(dataService.journeys)
      .receive(on: DispatchQueue.main)
      .assign(to: \.results, on: self)
      .store(in: &subscriptions)
  }

}

enum DateMode {
  case departure
  case arrival
}

struct JourneyQueryComponents {
  var originId: Int
  var destinationId: Int
  var date: String
  var dateMode: String
  var passengers: Int
  init(origin: Stop, destination: Stop, date: Date, dateMode: DateMode, passengers: Int) {
    self.originId = origin.id
    self.destinationId = destination.id
    self.date = JourneyQuery.dateFormatter.string(from: date)
    self.dateMode = (dateMode == .arrival) ? "ARRIVAL" : "DEPARTURE"
    self.passengers = passengers
  }
}
