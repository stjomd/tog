//
//  TicketsQuery.swift
//  tog
//
//  Created by Artem Zhukov on 04.10.21.
//

import Foundation
import Combine

class TicketsQuery: ObservableObject {

  @Autowired private var dataService: DataService!

  @Published var query: TicketSelection
  @Published var results: [Ticket] = []
  private var subscriptions: Set<AnyCancellable> = []

  init(_ selection: TicketSelection) {
    self.query = selection
    $query
      .flatMap(dataService.tickets)
      .receive(on: DispatchQueue.main)
      .print()
      .assign(to: \.results, on: self)
      .store(in: &subscriptions)
  }

  func reload() {
    let t = self.query
    self.query = .all
    self.query = t
  }

}

class TicketQueries: ObservableObject {
  static let placeholder = TicketQueries(valid: TicketsQuery(.valid), expired: TicketsQuery(.expired))
  @Published var valid: TicketsQuery
  @Published var expired: TicketsQuery
  init(valid: TicketsQuery, expired: TicketsQuery) {
    self.valid = valid
    self.expired = expired
  }
  func update() {
    self.valid = TicketsQuery(.valid)
    self.expired = TicketsQuery(.expired)
  }
}
