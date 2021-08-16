//
//  togApp.swift
//  tog
//
//  Created by Artem Zhukov on 11.08.21.
//

import SwiftUI
import Swinject
import CoreData.NSManagedObjectContext

@main
struct togApp: App {
  
  /// Core Data's managed object context type.
  typealias CDContext = NSManagedObjectContext
  /// Swinject Container.
  static let container = Container()
  
  var body: some Scene {
    WindowGroup {
      MainView()
    }
  }
  
  init() {
    registerDependencies()
  }
  
  private func registerDependencies() {
    Self.container.register(CDContext.self)    { _ in CoreDataStore.shared.persistentContainer.viewContext }
    Self.container.register(DataService.self)  { r in OEBBDataService(context: r.resolve(CDContext.self)!) }
    Self.container.register(ColorService.self) { _ in ColorService() }
  }
  
}
