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
  
  private let isUITest = ProcessInfo.processInfo.arguments.contains("UITEST")
  
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
    if isUITest {
      // Mock data (ÖBB's open data, predownloaded)
      Self.container.register(DataService.self)  { r in OEBBDataService(context: r.resolve(CDContext.self)!) }
    } else {
      // TODO: Register a real data service
      // Currently also mock data, since ÖBB doesn't offer any open API. In a real app the following line
      // should register a data service that actually fetches data from an API.
      Self.container.register(DataService.self)  { r in OEBBDataService(context: r.resolve(CDContext.self)!) }
    }
    Self.container.register(ColorService.self) { _ in ColorService() }
  }
  
}
