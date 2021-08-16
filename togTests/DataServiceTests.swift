//
//  DataServiceTests.swift
//  togTests
//
//  Created by Artem Zhukov on 16.08.21.
//

import XCTest
import CoreData
@testable import tog

class MockCoreDataStore {
  // Create an in-memory container
  var persistentContainer: NSPersistentContainer = {
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
  }()
}

class DataServiceTests: XCTestCase {
    
  var context: NSManagedObjectContext!
  var dataService: DataService!
  
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    try super.setUpWithError()
    context = MockCoreDataStore().persistentContainer.viewContext
    dataService = OEBBDataService(context: context, populate: false)
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
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
    print(cdStops.map { $0.name })
    print(dsStops.map { $0.name })
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
