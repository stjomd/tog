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
  let existingFavorite: FavoriteDestination?
  @Binding var isPresent: Bool

  private var amountRange =  1...5

  init(origin: Stop, destination: Stop, journeys: [Journey],
       existingFavorite: FavoriteDestination?, isPresent: Binding<Bool>) {
    self.origin = origin
    self.destination = destination
    self.journeys = journeys
    self.existingFavorite = existingFavorite
    self._isPresent = isPresent
    // Derived
    self._amount = State(initialValue: existingFavorite?.amount ?? amountRange.max()!)
  }

  @State var amount: Int = 5
  private var newFavorite: FavoriteDestination {
    FavoriteDestination(origin: origin, destination: destination, amount: amount)
  }
  private var journeysToShow: [Journey] {
    let bound = min(amount, journeys.count)
    return Array(journeys[..<bound])
  }

  var body: some View {
    NavigationView {
      Group {
        List {
          Section(header: Text("Settings")) {
            Stepper("Amount: \(amount)", value: $amount, in: amountRange)
          }
          Section(header: Text("Preview")) {
            VStack(alignment: .leading) {
              FavoriteJourneyTitle(favorite: newFavorite, isShowingMoreIcon: false,
                                   allFavorites: .constant([]))
              FavoriteJourneyTrips(journeys: journeysToShow)
            }
            .padding(.vertical, 10)
          }
        }
        .listStyle(InsetGroupedListStyle())
      }
      .navigationTitle(existingFavorite != nil ? "Edit Favorite" : "Add to Favorites")
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
            if let existingFavorite = existingFavorite {
              existingFavorite.amount = amount
              dataService.saveFavorite(existingFavorite)
            } else {
              dataService.saveFavorite(
                FavoriteDestination(origin: origin, destination: destination, amount: amount)
              )
            }
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
                       journeys: [.example, .example], existingFavorite: nil, isPresent: .constant(true))
  }
}
