//
//  DataServiceTests.swift
//  togTests
//
//  Created by Artem Zhukov on 16.08.21.
//

import XCTest
import Combine
@testable import tog

class DataServiceTests: XCTestCase {

  var dataService: MockableDataService!

  override func setUpWithError() throws {
    try super.setUpWithError()
    dataService = MockDataService(populate: false)
  }

  override func tearDownWithError() throws {
    dataService = nil
    try super.tearDownWithError()
  }

  func test_whenGivenStops_fetchingReturnsStops() throws {
    // When
    let stops = [
      Stop(id: 15, name: "Wien Hütteldorf", latitude: 0.5, longitude: 0.5),
      Stop(id: 18, name: "Wien Penzing", latitude: 0.5, longitude: 0.5),
      Stop(id: 54, name: "Wien Breitensee", latitude: 0.5, longitude: 0.5)
    ]
    dataService.mock(stops: stops)
    // Then
    _ = dataService.stops(by: "Wien").sink { XCTAssertEqual(stops.count, $0.count) }
    _ = dataService.stops(by: "te").sink { XCTAssertEqual(2, $0.count) }
  }

  func test_whenNoStops_FetchingReturnsEmptyArray() throws {
    // When
    dataService.mock(stops: [])
    // Then
    _ = dataService.stops(by: "").sink { XCTAssert($0.isEmpty) }
    _ = dataService.stops(by: "Wien").sink { XCTAssert($0.isEmpty) }
  }

}
