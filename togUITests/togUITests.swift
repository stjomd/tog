//
//  togUITests.swift
//  togUITests
//
//  Created by Artem Zhukov on 11.08.21.
//

import XCTest

class TogUITests: XCTestCase {

  var app: XCUIApplication!

  override func setUpWithError() throws {
    try super.setUpWithError()
    continueAfterFailure = false
    app = XCUIApplication()
    app.launchArguments.append("UITEST")
    app.launch()
  }

  override func tearDownWithError() throws {
    app = nil
    try super.tearDownWithError()
  }

  // TODO: Disabled (attempt to read env var - use mock data service!)

//  func test_whenBothStopsChosen_thenFindTicketsButton() throws {
//
//    let tablesQuery = XCUIApplication().tables
//    let originTextField = tablesQuery.textFields["Origin"]
//    let destinationTextField = tablesQuery.textFields["Destination"]
//    // When
//    XCTAssertFalse(tablesQuery.buttons["Find tickets..."].exists)
//    originTextField.tap()
//    originTextField.typeText("Penzing")
//    tablesQuery.cells["Wien Penzing Bahnhof"].buttons["Wien Penzing Bahnhof"].tap()
//
//    XCTAssertFalse(tablesQuery.buttons["Find tickets..."].exists)
//    destinationTextField.typeText("Hütteldorf")
//    tablesQuery.cells["Wien Hütteldorf Bahnhof"].buttons["Wien Hütteldorf Bahnhof"].tap()
//
//    // Then
//    XCTAssertTrue(tablesQuery.buttons["Find tickets..."].exists)
//    tablesQuery.buttons["Find tickets..."].tap()
//
//    XCTAssertTrue(app.staticTexts["Wien Penzing Bahnhof"].exists)
//    XCTAssertTrue(app.staticTexts["Wien Hütteldorf Bahnhof"].exists)
//  }
//
//  func test_whenBothStopsChosenAndInputTextChanges_thenNoFindTicketsButton() throws {
//    let tablesQuery = XCUIApplication().tables
//    let originTextField = tablesQuery.textFields["Origin"]
//    let destinationTextField = tablesQuery.textFields["Destination"]
//    // When
//    XCTAssertFalse(tablesQuery.buttons["Find tickets..."].exists)
//    originTextField.tap()
//    originTextField.typeText("Penzing")
//    tablesQuery.cells["Wien Penzing Bahnhof"].buttons["Wien Penzing Bahnhof"].tap()
//    XCTAssertFalse(tablesQuery.buttons["Find tickets..."].exists)
//    destinationTextField.typeText("Hütteldorf")
//    tablesQuery.cells["Wien Hütteldorf Bahnhof"].buttons["Wien Hütteldorf Bahnhof"].tap()
//    XCTAssertTrue(tablesQuery.buttons["Find tickets..."].exists)
//    // And when (1 - destination input doesn't match)
//    destinationTextField.tap()
//    app.keyboards.keys["delete"].tap()
//    // Then (1 - Find tickets button is hidden)
//    XCTAssertFalse(tablesQuery.buttons["Find tickets..."].exists)
//    // -- Restore (1) in preparation for (2)
//    destinationTextField.typeText(" Bahnhof") // restore destination text field
//    XCTAssertTrue(tablesQuery.buttons["Find tickets..."].exists)
//    // And when (2 - origin input doesn't match)
//    originTextField.tap()
//    app.keyboards.keys["delete"].tap()
//    // Then (2 - Find tickets button is hidden)
//    XCTAssertFalse(tablesQuery.buttons["Find tickets..."].exists)
//  }

}
