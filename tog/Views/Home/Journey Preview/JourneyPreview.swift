//
//  JourneyPreview.swift
//  tog
//
//  Created by Artem Zhukov on 03.10.21.
//

import SwiftUI

struct JourneyPreview: View {

  @Autowired private var dataService: DataService!

  let journey: Journey

  @State private var isShowingMap = false
  @State private var isShowingAlert = false

  private var canBuy: Bool {
    Date() < journey.departure
  }

  var body: some View {
    ScrollView(showsIndicators: false) {
      VStack(alignment: .leading) {
        // MARK: Top info
        HStack(alignment: .lastTextBaseline) {
          Text(journey.durationString)
          Spacer()
          Text(journey.priceString)
            .font(.title)
            .bold()
        }
        .padding(.top, 0)
        .padding(.bottom, -4)
        Divider()
        // MARK: Buttons
        HStack {
          FlatButton(disabled: false, action: {
            isShowingMap = true
          }, contents: {
            Globals.Icons.map
            Text("Show Map")
          })
          FlatButton(disabled: !canBuy, action: {
            isShowingAlert = true
          }, contents: {
            Globals.Icons.money
            Text("Buy")
          })
          .alert(isPresented: $isShowingAlert) {
            Alert(
              title: Text("Buying Simulation"),
              message: Text("Pretend this is a real purchase!"),
              primaryButton: .default(Text("Buy"), action: {
                print("ARRDATE")
                print(journey.arrival)
                let ticket = Ticket(journey: journey, expiration: journey.arrival, passengers: journey.passengers)
                dataService.buyTicket(ticket)
              }),
              secondaryButton: .cancel()
            )
          }
        }
        Divider()
        // MARK: Journey legs
        JourneyLegsPreview(journey: journey)
      }
      .padding(.horizontal)
      .padding(.bottom, 16)
    }
    .sheet(isPresented: $isShowingMap, onDismiss: {}) {
      JourneyMap(journey: journey)
        .edgesIgnoringSafeArea(.bottom)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .navigationTitle("Journey Preview")
    .navigationBarTitleDisplayMode(.inline)
  }

}

struct JourneyLegsPreview: View {

  let journey: Journey

  var body: some View {
    VStack(alignment: .leading) {
      ForEach(journey.legs, id: \.self) { leg in
        ZStack(alignment: .leading) {
          RoundedRectangle(cornerRadius: 6)
            .opacity(0.1)
          HStack {
            Text(leg.trip.name)
              .fontWeight(.bold)
            Text(leg.trip.headsign)
          }
          .padding(.horizontal, 8)
          .padding(.vertical, 4)
        }
        ForEach(leg.halts, id: \.id) { halt in
          HaltRow(halt: halt, leg: leg)
        }
        if leg.trip.id != journey.legs.last!.trip.id {
          Divider()
            .padding(.bottom, 4)
          if let transferTime = journey.transferTimeString(after: leg) {
            Text("\(transferTime) to transfer in \(leg.halts.last!.stop.name)")
          } else {
            Text("Transfer in \(leg.halts.last!.stop.name)")
          }
          Divider()
        }
      }
    }
  }

}

struct HaltRow: View {

  let halt: Halt
  let leg: JourneyLeg

  private let trackColor = Globals.Colors.mapPolyline

  var body: some View {
    HStack {
      // Arrows & Time
      if halt.isLastIn(leg: leg) {
        Globals.Icons.arrivalArrow
        Text(halt.arrival.timeString)
          .frame(width: 50, alignment: .center)
      } else {
        // Show arrow on first halt in a leg, "hide" the rest
        if halt.isFirstIn(leg: leg) {
          Globals.Icons.departureArrow
        } else {
          Globals.Icons.departureArrow
            .foregroundColor(Globals.Colors.monochrome)
        }
        Text(halt.departure.timeString)
          .frame(width: 50, alignment: .center)
      }
      // Circle & Stop & Platform
      if halt.isFirstIn(leg: leg) {
        // First halt in a leg
        Circle()
          .foregroundColor(trackColor)
          .frame(width: 15, height: 15)
        Text(halt.stop.name)
          .bold()
          .lineLimit(1)
        Text("3") // platform - placeholder (not provided in the data)
          .fontWeight(.thin)
      } else if halt.isLastIn(leg: leg) {
        // Last halt in a leg
        Circle()
          .foregroundColor(trackColor)
          .frame(width: 15, height: 15)
          .overlay(circleConnector)
        Text(halt.stop.name)
          .bold()
          .lineLimit(1)
        Text("4") // platform - placeholder (not provided in the data)
          .fontWeight(.thin)
      } else {
        // All other halts
        VStack {
          Circle()
            .foregroundColor(trackColor)
            .frame(width: 10, height: 10)
            .overlay(circleConnector)
        }
        .frame(width: 15, height: 15, alignment: .center)
        Text(halt.stop.name)
          .lineLimit(1)
      }
    }
  }

  private var circleConnector: some View {
    Rectangle()
      .foregroundColor(trackColor)
      .frame(width: 3, height: 25)
      .offset(y: -17)
  }

}

struct JourneyPreview_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      JourneyPreview(journey: .example)
    }
    NavigationView {
      JourneyPreview(journey: .example)
    }
    .preferredColorScheme(.dark)
  }
}
