//
//  ColorServiceTests.swift
//  togTests
//
//  Created by Artem Zhukov on 16.08.21.
//

import XCTest
import SwiftUI
@testable import tog

class ColorServiceTests: XCTestCase {
  
  var colorService: ColorService!
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    colorService = ColorService()
  }
  
  override func tearDownWithError() throws {
    colorService = nil
    try super.tearDownWithError()
  }
  
  func test_whenBlackBackground_chooseContrastingWhite() throws {
    // When
    let components = ColorComponents(red: 0, green: 0, blue: 0) // black
    let contrasting = components.contrastingColor(bright: .white, dark: .black)
    // Then
    XCTAssertEqual(contrasting, colorService.choose(bright: .white, dark: .black, against: components))
  }
  
  func test_whenWhiteBackground_chooseContrastingBlack() throws {
    // When
    let components = ColorComponents(red: 1, green: 1, blue: 1) // white
    let contrasting = components.contrastingColor(bright: .white, dark: .black)
    // Then
    XCTAssertEqual(contrasting, colorService.choose(bright: .white, dark: .black, against: components))
  }
  
  func test_whenGeneratingColorFromString() throws {
    // No requirements on this method really
    XCTAssertNoThrow(colorService.components(from: "Hello, world!"))
  }
  
}
