//
//  FavoriteDestination.swift
//  tog
//
//  Created by Artem Zhukov on 23.08.21.
//

import Foundation

class FavoriteDestination: Codable {

  var id: UUID

  var origin: Stop?

  var destination: Stop?

  var amount: Int

  init(origin: Stop, destination: Stop, amount: Int) {
    self.id = UUID()
    self.origin = origin
    self.destination = destination
    self.amount = amount
  }

}
