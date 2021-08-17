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

  // Cache model to prevent errors when unit testing:
  // (Multiple NSEntityDescriptions claim the NSManagedObject subclass 'Stop' so +entity is unable to disambiguate.)
  static let model: NSManagedObjectModel? = {
    guard let modelURL = Bundle.main.url(forResource: "Model", withExtension: "momd"),
          let model = NSManagedObjectModel(contentsOf: modelURL) else {
      return nil
    }
    return model
  }()

  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "Model", managedObjectModel: CoreDataStore.model!)
    container.loadPersistentStores { _, error in
      if let error = error {
        print(error)
      }
    }
    return container
  }()

  private init() {
  }

}
