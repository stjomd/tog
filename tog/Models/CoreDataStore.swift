//
//  CoreDataStore.swift
//  tog
//
//  Created by Artem Zhukov on 14.08.21.
//

import Foundation
import CoreData

class CoreDataStore {
  
  static let shared = CoreDataStore()
  
  var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "Model")
    container.loadPersistentStores { description, error in
      if let error = error {
        print(error)
      }
    }
    return container
  }()
  
  private init() {
  }
  
}
