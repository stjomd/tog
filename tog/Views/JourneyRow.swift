//
//  JourneyRow.swift
//  tog
//
//  Created by Artem Zhukov on 22.08.21.
//

import SwiftUI

struct JourneyRow: View {

  @Autowired private var colorService: ColorService!

  let journey: Journey

  var body: some View {
    HStack {
      Text(journey.departure.shortDescription)
      Rectangle()
        .foregroundColor(Color.gray.opacity(0.2))
        .overlay(
          Rectangle()
            .foregroundColor(colorService.color(for: journey.legs.first!.trip.trainCode))
            .frame(height: 2),
          alignment: .bottom
        )
        .overlay(
          Text(journey.legs.first!.trip.name)
            .font(.callout)
        )
        .frame(height: 28)
        .cornerRadius(6)
        .padding(.horizontal, 2)
      Text(journey.arrival.shortDescription)
    }
  }

}

struct JourneyRow_Previews: PreviewProvider {

  static var previews: some View {
    JourneyRow(journey: Journey.example)
      .padding()
      .previewLayout(.sizeThatFits)
    JourneyRow(journey: Journey.example)
      .padding()
      .previewLayout(.sizeThatFits)
      .preferredColorScheme(.dark)
  }

}
