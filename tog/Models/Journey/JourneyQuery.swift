//
//  JourneyQuery.swift
//  tog
//
//  Created by Artem Zhukov on 22.08.21.
//

import Foundation
import Combine

class JourneyQuery: ObservableObject {

  // MARK: - Properties

  @Autowired private var dataService: DataService!

  @Published var query: JourneyQueryComponents = JourneyQueryComponents()
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
  var origin: Stop
  var destination: Stop
  var date: Date
  var dateMode: DateMode
  var passengers: Int
  init(origin: Stop, destination: Stop, date: Date, dateMode: DateMode, passengers: Int) {
    self.origin = origin
    self.destination = destination
    self.date = date
    self.dateMode = dateMode
    self.passengers = passengers
  }
  init() {
    self.origin = Stop(id: -1, name: "", latitude: 0, longitude: 0)
    self.destination = Stop(id: -2, name: "", latitude: 0, longitude: 0)
    self.date = Date()
    self.dateMode = .departure
    self.passengers = 0
  }
}
