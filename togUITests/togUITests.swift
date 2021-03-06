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

  func test_whenBothStopsChosen_thenFindTicketsButton() throws {

    let tablesQuery = XCUIApplication().tables
    let originTextField = tablesQuery.textFields["Origin"]
    let destinationTextField = tablesQuery.textFields["Destination"]
    // When
    XCTAssertFalse(tablesQuery.buttons["Find tickets..."].exists)
    originTextField.tap()
    originTextField.typeText("Penzing")
    tablesQuery.cells["Wien Penzing Bahnhof"].buttons["Wien Penzing Bahnhof"].tap()

    XCTAssertFalse(tablesQuery.buttons["Find tickets..."].exists)
    destinationTextField.typeText("Hütteldorf")
    tablesQuery.cells["Wien Hütteldorf Bahnhof"].buttons["Wien Hütteldorf Bahnhof"].tap()

    // Then
    XCTAssertTrue(tablesQuery.buttons["Find tickets..."].exists)
    tablesQuery.buttons["Find tickets..."].tap()

    XCTAssertTrue(app.staticTexts["Wien Penzing Bahnhof"].exists)
    XCTAssertTrue(app.staticTexts["Wien Hütteldorf Bahnhof"].exists)
  }

  func test_whenBothStopsChosenAndInputTextChanges_thenNoFindTicketsButton() throws {
    let tablesQuery = XCUIApplication().tables
    let originTextField = tablesQuery.textFields["Origin"]
    let destinationTextField = tablesQuery.textFields["Destination"]
    // When
    XCTAssertFalse(tablesQuery.buttons["Find tickets..."].exists)
    originTextField.tap()
    originTextField.typeText("Penzing")
    tablesQuery.cells["Wien Penzing Bahnhof"].buttons["Wien Penzing Bahnhof"].tap()
    XCTAssertFalse(tablesQuery.buttons["Find tickets..."].exists)
    destinationTextField.typeText("Hütteldorf")
    tablesQuery.cells["Wien Hütteldorf Bahnhof"].buttons["Wien Hütteldorf Bahnhof"].tap()
    XCTAssertTrue(tablesQuery.buttons["Find tickets..."].exists)
    // And when (1 - destination input doesn't match)
    destinationTextField.tap()
    app.keyboards.keys["delete"].tap()
    // Then (1 - Find tickets button is hidden)
    XCTAssertFalse(tablesQuery.buttons["Find tickets..."].exists)
    // -- Restore (1) in preparation for (2)
    destinationTextField.typeText(" Bahnhof") // restore destination text field
    XCTAssertTrue(tablesQuery.buttons["Find tickets..."].exists)
    // And when (2 - origin input doesn't match)
    originTextField.tap()
    app.keyboards.keys["delete"].tap()
    // Then (2 - Find tickets button is hidden)
    XCTAssertFalse(tablesQuery.buttons["Find tickets..."].exists)
  }

  func test_whenInJourneySearchAndAddToFavorite_thenFavoriteOnMainScreen() throws {
    let (originName, destinationName) = ("Wien Hütteldorf Bahnhof", "Wien Westbahnhof")
    let (originKey, destinationKey) = (originName.first!.description, destinationName.first!.description)
    // When
    XCTAssertTrue(app.staticTexts["Frequented Destinations"].exists)
    // -- Search
    let tablesQuery = app.tables
    tablesQuery.textFields["Origin"].tap()
    app.keys[originKey].tap()
    tablesQuery.buttons[originName].tap()
    app.keys[destinationKey].tap()
    tablesQuery.buttons[destinationName].tap()
    tablesQuery.buttons["Find tickets..."].tap()
    // -- Add to favorites
    let selectJourneyNavigationBar = app.navigationBars["Select Journey"]
    selectJourneyNavigationBar.buttons["starButton"].tap()
    app.navigationBars["Add to Favorites"].buttons["Save"].tap()
    // -- Go back
    selectJourneyNavigationBar.buttons["Tog"].tap()
    // Then
    let favoriteCell = tablesQuery.cells.element(boundBy: 3)
    XCTAssertTrue(favoriteCell.exists)
    XCTAssertTrue(favoriteCell.staticTexts[originName].exists)
    XCTAssertTrue(favoriteCell.staticTexts[destinationName].exists)
    XCTAssertFalse(app.staticTexts["Frequented Destinations"].exists)
  }

  func test_whenInJourneySearchAndSelectJourney_thenShowPreview() throws {
    let (originName, destinationName) = ("Wien Hütteldorf Bahnhof", "Wien Westbahnhof")
    let (originKey, destinationKey) = (originName.first!.description, destinationName.first!.description)
    // When
    // -- Search
    let tablesQuery = app.tables
    tablesQuery.textFields["Origin"].tap()
    app.keys[originKey].tap()
    tablesQuery.buttons[originName].tap()
    app.keys[destinationKey].tap()
    tablesQuery.buttons[destinationName].tap()
    tablesQuery.buttons["Find tickets..."].tap()
    // -- Tap the first journey cell
    tablesQuery.cells.element(boundBy: 4).tap()
    // Then
    XCTAssertTrue(app.staticTexts["Wien Penzing Bahnhof"].exists) // station between
    XCTAssertTrue(app.staticTexts["S50"].exists) // train code
  }

  func test_whenInJourneyPreviewAndBuyTicket_thenTicketInTicketsTab() throws {
    let (originName, destinationName) = ("Wien Hütteldorf Bahnhof", "Wien Westbahnhof")
    let (originKey, destinationKey) = (originName.first!.description, destinationName.first!.description)
    // When
    // -- Search
    let tablesQuery = app.tables
    tablesQuery.textFields["Origin"].tap()
    app.keys[originKey].tap()
    tablesQuery.buttons[originName].tap()
    app.keys[destinationKey].tap()
    tablesQuery.buttons[destinationName].tap()
    tablesQuery.buttons["Find tickets..."].tap()
    // -- Tap the first journey cell
    tablesQuery.cells.element(boundBy: 4).tap()
    // -- Tap Buy
    app.scrollViews.otherElements.buttons["Buy"].tap()
    app.alerts["Buying Simulation"].scrollViews.otherElements.buttons["Buy"].tap()
    // -- !!! Bug? Need to switch back and forth for the ticket to appear
    app.tabBars["Tab Bar"].buttons["Tickets"].tap()
    app.tabBars["Tab Bar"].buttons["Home"].tap()
    app.tabBars["Tab Bar"].buttons["Tickets"].tap()
    // Then
    XCTAssertFalse(app.staticTexts["No tickets"].exists)
  }

}
