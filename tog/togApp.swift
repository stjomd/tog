//
//  togApp.swift
//  tog
//
//  Created by Artem Zhukov on 11.08.21.
//

import SwiftUI

@main
struct togApp: App {
  
  let dataService: DataService
  let context = CoreDataStore.shared.persistentContainer.viewContext
  
  var body: some Scene {
    WindowGroup {
      MainView()
        .environment(\.managedObjectContext, context)
        .environmentObject(dataService)
    }
  }
  
  init() {
    self.dataService = OEBBDataService(context: context)
  }
  
}
