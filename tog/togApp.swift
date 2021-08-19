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
struct TogApp: App {

  static let isUITest = ProcessInfo.processInfo.arguments.contains("UITEST")

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

  // MARK: - Register components with Swinject

  private func registerDependencies() {
    // NSManagedObjectContext
    Self.container.register(CDContext.self) { _ in CoreDataStore.shared.persistentContainer.viewContext }
    // DataService
    let dataService = retrieveDataService()
    Self.container.register(DataService.self) { _ in dataService }
    // ColorService
    let colorService = ColorService()
    Self.container.register(ColorService.self) { _ in colorService }
  }

  private func retrieveDataService() -> DataService {
    if TogApp.isUITest {
      // Mock data (ÖBB's open data, predownloaded)
      // return MockDataService(context: TogApp.container.resolve(CDContext.self)!, populate: true)
      return TogDataService() // change to ^
    } else {
      // NOTE: Register a real data service
      // Currently also mock data, since ÖBB doesn't offer any open API. In a real app the following line
      // should register a data service that actually fetches data from an API.
      return TogDataService()
    }
  }

}
