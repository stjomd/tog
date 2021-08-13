//
//  togApp.swift
//  tog
//
//  Created by Artem Zhukov on 11.08.21.
//

import SwiftUI

@main
struct togApp: App {
  let dataService: DataService = OEBBDataService()
  var body: some Scene {
    WindowGroup {
      MainView()
        .environmentObject(dataService)
    }
  }
}
