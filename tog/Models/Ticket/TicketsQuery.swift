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
      .assign(to: \.results, on: self)
      .store(in: &subscriptions)
  }

  func reload() {
    let t = self.query
    self.query = .all
    self.query = t
  }

}
