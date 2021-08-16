//
//  DataServiceTests.swift
//  togTests
//
//  Created by Artem Zhukov on 16.08.21.
//

import XCTest
import CoreData
import Swinject
@testable import tog

class MockCoreData: CoreDataStore {
  // Create an in-memory container
  override var persistentContainer: NSPersistentContainer {
    let description = NSPersistentStoreDescription()
    description.type = NSInMemoryStoreType
    let container = NSPersistentContainer(name: "Model")
    container.persistentStoreDescriptions = [description]
    container.loadPersistentStores { description, error in
      if let error = error {
        print(error)
      }
    }
    return container
  }
}

class DataServiceTests: XCTestCase {
  
  var container: Container!
  var coreDataStore: CoreDataStore!
  
  var context: NSManagedObjectContext!
  var dataService: DataService!
  
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    try super.setUpWithError()
    // Core Data
    coreDataStore = MockCoreData()
    let cdContext = coreDataStore.persistentContainer.viewContext
    // DI Registration
    container = Container()
    container.register(NSManagedObjectContext.self, factory: { _ in cdContext })
    container.register(DataService.self, factory: { r in OEBBDataService(context: r.resolve(NSManagedObjectContext.self)!) })
    // Injection
    context = cdContext
    dataService = container.resolve(DataService.self)
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    container = nil
    coreDataStore = nil
    context = nil
    dataService = nil
    try super.tearDownWithError()
  }
  
  func test_whenGivenStops_fetchingReturnsStops() throws {
    // When
    Stop.createWith(id: 15, name: "Wien Hütteldorf", latitude: 0.5, longitude: 0.5, using: context)
    Stop.createWith(id: 18, name: "Wien Penzing", latitude: 0.5, longitude: 0.5, using: context)
    Stop.createWith(id: 54, name: "Wien Breitensee", latitude: 0.5, longitude: 0.5, using: context)
    try context.save()
    let cdStops = try context.fetch(Stop.fetchRequest()) as [Stop]
    // Then
    let dsStops = dataService.stops(by: "Wien")
    XCTAssertEqual(cdStops.count, dsStops.count)
  }
  
  func test_whenNoStops_FetchingReturnsEmptyArray() throws {
    // When no stops
    let request: NSFetchRequest<Stop> = Stop.fetchRequest()
    let stops = try context.fetch(request) as [Stop]
    XCTAssertTrue(stops.isEmpty)
    // Then
    XCTAssertTrue(dataService.stops(by: "").isEmpty)
  }
  
}
