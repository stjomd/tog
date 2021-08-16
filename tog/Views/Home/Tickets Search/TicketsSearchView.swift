//
//  TicketsSearchView.swift
//  tog
//
//  Created by Artem Zhukov on 15.08.21.
//

import SwiftUI

struct TicketsSearchView: View {

  let origin: Stop
  let destination: Stop

  var body: some View {
    VStack {
      Text(origin.name)
      Image(systemName: "arrow.down")
      Text(destination.name)
    }
  }

}

struct TicketsSearchView_Previews: PreviewProvider {

  @Autowired
  private static var dataService: DataService!
  private static var results = dataService.stops(by: "Wien")

  static var previews: some View {
    TicketsSearchView(origin: results[0], destination: results[1])
  }

}
