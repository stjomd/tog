//
//  AddToFavoritesView.swift
//  tog
//
//  Created by Artem Zhukov on 23.08.21.
//

import SwiftUI

struct AddToFavoritesView: View {

  @Autowired private var dataService: DataService!

  let origin: Stop
  let destination: Stop
  let journeys: [Journey]

  private var favorite: FavoriteDestination {
    FavoriteDestination(origin: origin, destination: destination, amount: amount)
  }

  @State var amount = 5
  var journeysToShow: [Journey] {
    let bound = min(amount, journeys.count)
    return Array(journeys[..<bound])
  }

  @Binding var isPresent: Bool

  var body: some View {
    NavigationView {
      Group {
        List {
          Section(header: Text("Settings")) {
            Stepper("Amount: \(amount)", value: $amount, in: 1...5)
          }
          Section(header: Text("Preview")) {
            VStack(alignment: .leading) {
              FavoriteJourneyTitle(favorite: favorite, query: nil, isShowingMoreIcon: false)
              FavoriteJourneyTrips(journeys: journeysToShow)
            }
            .padding(.vertical, 10)
          }
        }
        .listStyle(InsetGroupedListStyle())
      }
      .navigationTitle("Add to Favorites")
      .navigationBarItems(
        leading:
          Button(action: {
            dismiss()
          }, label: {
            Text("Cancel")
              .foregroundColor(.red)
          }),
        trailing:
          Button(action: {
            dataService.addFavorite(
              FavoriteDestination(origin: origin, destination: destination, amount: amount)
            )
            dismiss()
          }, label: {
            Text("Save")
          })
      )
    }
  }

  private func dismiss() {
    isPresent = false
  }

}

struct AddToFavoritesView_Previews: PreviewProvider {
  static var previews: some View {
    AddToFavoritesView(origin: Stop.penzing, destination: Stop.westbahnhof,
                       journeys: [.example, .example], isPresent: .constant(true))
  }
}
