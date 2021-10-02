//
//  FavoritesQuery.swift
//  tog
//
//  Created by Artem Zhukov on 24.08.21.
//

import Foundation
import Combine

class FavoritesQuery: ObservableObject {

  @Autowired private var dataService: DataService!

  @Published var results: [FavoriteDestination] = []
  private var subscriptions: Set<AnyCancellable> = []

  init() {
    dataService.favorites()
      .assign(to: \.results, on: self)
      .store(in: &subscriptions)
  }

}
