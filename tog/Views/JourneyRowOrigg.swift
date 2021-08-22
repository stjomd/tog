//
//  JourneyRow.swift
//  tog
//
//  Created by Artem Zhukov on 12.08.21.
//

import SwiftUI

struct JourneyRowOrigg: View {

  let journey: JourneyOrigg
  var dateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    return formatter
  }

  var body: some View {
    HStack {
      Text(dateFormatter.string(from: journey.departure))
      Rectangle()
        .foregroundColor(Color.gray.opacity(0.2))
        .overlay(
          Rectangle()
            .foregroundColor(color(for: journey.train))
            .frame(height: 2),
          alignment: .bottom
        )
        .overlay(
          Text(journey.train)
            .font(.callout)
        )
        .frame(height: 28)
        .padding(.horizontal, 4)
      Text(dateFormatter.string(from: journey.arrival))
    }
  }

  private func color(for train: String) -> Color {
    switch train {
    case "REX", "CJX":
      return Globals.Colors.Transport.rex
    case _ where train.hasPrefix("S"):
      return Globals.Colors.Transport.sBahn
    default:
      return Globals.Colors.Transport.other
    }
  }

}

struct JourneyRowOrigg_Previews: PreviewProvider {
  static var previews: some View {
    JourneyRowOrigg(journey: .cjx)
      .previewLayout(.sizeThatFits)
      .padding()
    JourneyRowOrigg(journey: .cjx)
      .previewLayout(.sizeThatFits)
      .preferredColorScheme(.dark)
      .padding()
  }
}
