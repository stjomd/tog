//
//  CoreDataStore.swift
//  tog
//
//  Created by Artem Zhukov on 14.08.21.
//

import Foundation
import CoreData

class CoreDataStore {
  
  // Must not be stored (& lazy) to be overridden as a mock in unit tests
  var persistentContainer: NSPersistentContainer {
    let container = NSPersistentContainer(name: "Model")
    container.loadPersistentStores { description, error in
      if let error = error {
        print(error)
      }
    }
    return container
  }
  
  init() {
  }
  
}
