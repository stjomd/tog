//
//  togApp.swift
//  tog
//
//  Created by Artem Zhukov on 11.08.21.
//

import SwiftUI
import Swinject
import RealmSwift

@main
struct TogApp: SwiftUI.App {

  static let calendar = Calendar.current
  static let isUITest = ProcessInfo.processInfo.arguments.contains("UITEST")

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
    // Realm
    do {
      let realm = try Realm()
      print(Realm.Configuration.defaultConfiguration.fileURL!.absoluteString)
      Self.container.register(Realm.self) { _ in realm }
    } catch {
      fatalError("Couldn't open Realm file: \(error)")
    }
    // DataService
    let dataService = retrieveDataService()
    Self.container.register(DataService.self) { _ in dataService }
    // ColorService
    let colorService = ColorService()
    Self.container.register(ColorService.self) { _ in colorService }
  }

  private func retrieveDataService() -> DataService {
    if TogApp.isUITest {
      return MockDataService(populate: true)
    } else {
      return TogDataService()
    }
  }

}
