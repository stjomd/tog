//
//  TimeTests.swift
//  togTests
//
//  Created by Artem Zhukov on 17.08.21.
//

import XCTest
@testable import tog

// swiftlint:disable comma

class TimeTests: XCTestCase {

  let a = Time(hours: 12, minutes: 12, seconds: 12)

  func test_numeric_whenNegativeInput_thenNil() throws {
    // One input
    XCTAssertNil(Time(hours: -1, minutes: 30, seconds: 30)) // h
    XCTAssertNil(Time(hours: 12, minutes: -1, seconds: 30)) // m
    XCTAssertNil(Time(hours: 12, minutes: 30, seconds: -1)) // s
    // Two inputs
    XCTAssertNil(Time(hours: -1, minutes: -1, seconds: 30)) // hm
    XCTAssertNil(Time(hours: 12, minutes: -1, seconds: -1)) // ms
    XCTAssertNil(Time(hours: -1, minutes: 30, seconds: -1)) // hs
    // Three inputs
    XCTAssertNil(Time(hours: -1, minutes: -1, seconds: -1)) // hms
  }

  func test_numeric_whenTooLargeInput_thenNil() throws {
    // One input
    XCTAssertNil(Time(hours: 24, minutes: 30, seconds: 30)) // h
    XCTAssertNil(Time(hours: 12, minutes: 60, seconds: 30)) // m
    XCTAssertNil(Time(hours: 12, minutes: 30, seconds: 60)) // s
    // Two inputs
    XCTAssertNil(Time(hours: 24, minutes: 60, seconds: 30)) // hm
    XCTAssertNil(Time(hours: 12, minutes: 60, seconds: 60)) // ms
    XCTAssertNil(Time(hours: 24, minutes: 30, seconds: 60)) // hs
    // Three inputs
    XCTAssertNil(Time(hours: 24, minutes: 60, seconds: 60)) // hms
  }

  func test_numeric_whenOKInput_thenNotNil() throws {
    XCTAssertNotNil(Time(hours: 0,  minutes: 0,  seconds: 0))
    XCTAssertNotNil(Time(hours: 23, minutes: 59, seconds: 59))
  }

  func test_string_whenInvalidInput_thenNil() throws {
    XCTAssertNil(Time(""))
    XCTAssertNil(Time(":"))
    XCTAssertNil(Time("::"))
    XCTAssertNil(Time("abc"))
    XCTAssertNil(Time("ab:cd"))
    XCTAssertNil(Time("ab:cd:ef"))
    XCTAssertNil(Time("12"))
    XCTAssertNil(Time("24:00"))
    XCTAssertNil(Time("24:00:00"))
    XCTAssertNil(Time("24:00:00:00"))
    XCTAssertNil(Time("-12:30"))
    XCTAssertNil(Time("-12:-30"))
    XCTAssertNil(Time("-12:-30:-30"))
  }

  func test_string_whenOKInput_thenNotNil() throws {
    let time1 = Time("0:0")
    XCTAssertNotNil(time1)
    XCTAssertEqual(0, time1?.hours)
    XCTAssertEqual(0, time1?.minutes)
    XCTAssertEqual(0, time1?.seconds)
    let time2 = Time("12:30")
    XCTAssertNotNil(time2)
    XCTAssertEqual(12, time2?.hours)
    XCTAssertEqual(30, time2?.minutes)
    XCTAssertEqual(0, time2?.seconds)
    let time3 = Time("23:59:59")
    XCTAssertNotNil(time3)
    XCTAssertEqual(23, time3?.hours)
    XCTAssertEqual(59, time3?.minutes)
    XCTAssertEqual(59, time3?.seconds)
  }

  func test_description() throws {
    XCTAssertEqual("00:00:00", Time("0:0")?.description)
    XCTAssertEqual("00:00:00", Time("0:00")?.description)
    XCTAssertEqual("12:30:00", Time("12:30")?.description)
    XCTAssertEqual("12:30:59", Time("12:30:59")?.description)
    XCTAssertEqual("00:00:00", Time(hours: 0,  minutes: 0,  seconds: 0)?.description)
    XCTAssertEqual("00:00:59", Time(hours: 0,  minutes: 0,  seconds: 59)?.description)
    XCTAssertEqual("00:59:59", Time(hours: 0,  minutes: 59, seconds: 59)?.description)
    XCTAssertEqual("23:59:59", Time(hours: 23, minutes: 59, seconds: 59)?.description)
  }

}
