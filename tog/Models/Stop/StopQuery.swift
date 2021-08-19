//
//  StopQuery.swift
//  tog
//
//  Created by Artem Zhukov on 19.08.21.
//

import Foundation
import Combine

class StopQuery: ObservableObject {

  @Autowired private var dataService: DataService!

  @Published var query = ""
  @Published var results: [Stop] = []
  private var subscriptions: Set<AnyCancellable> = []

  init() {
    $query
      .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
      .flatMap(dataService.stops)
      .receive(on: DispatchQueue.main)
      .assign(to: \.results, on: self)
      .store(in: &subscriptions)
  }

}
