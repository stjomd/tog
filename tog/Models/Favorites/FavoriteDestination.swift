//
//  FavoriteDestination.swift
//  tog
//
//  Created by Artem Zhukov on 23.08.21.
//

import Foundation
import RealmSwift

class FavoriteDestination: Object {

  @Persisted(primaryKey: true)
  var id: ObjectId

  @Persisted
  var origin: Stop?

  @Persisted
  var destination: Stop?

  @Persisted
  var amount: Int

  // `origin` and `destination` have to be declared as optional because of Realm requirements.
  // These are guaranteed to have a value.

  convenience init(origin: Stop, destination: Stop, amount: Int) {
    self.init()
    self.origin = origin
    self.destination = destination
    self.amount = amount
  }

}
