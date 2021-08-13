//
//  ProductCell.swift
//  tog
//
//  Created by Artem Zhukov on 12.08.21.
//

import SwiftUI

struct ProductCell: View {
  
  let title: String
  let description: String
  let image: Image?
  
  private var circleColor: Color
  private var circleTextColor: Color
  
  var body: some View {
    HStack(alignment: .top) {
      Circle()
        .foregroundColor(circleColor)
        .frame(width: 40, height: 40)
        .overlay(
          image
            .foregroundColor(circleTextColor)
        )
        .overlay(
          image == nil
          ? Text(String(title.first ?? " "))
            .font(.title3)
            .foregroundColor(circleTextColor)
            .bold()
          : nil
        )
        .padding(.trailing, 4)
      VStack(alignment: .leading) {
        Text(title)
          .font(.headline)
        Text(description)
          .font(.subheadline)
      }
    }
    .padding(.vertical, 6)
  }
  
  init(title: String, description: String, image: Image? = nil) {
    self.title = title
    self.description = description
    self.image = image
    // Color setup
    let colorComponents = ColorService.components(from: title)
    self.circleColor = colorComponents.color
    self.circleTextColor = colorComponents.contrastingColor(bright: .white, dark: .black)
  }
  
  
}

struct ProductCell_Previews: PreviewProvider {
  static let alphabet: [Character] = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
  static var previews: some View {
    
    ProductCell(title: "Easy-Out-Ticket", description: "Local transport tickets for 2–5 passengers", image: Image(systemName: "person.2.fill"))
      .previewLayout(.sizeThatFits)
      .padding()
    
    ProductCell(title: "Vienna", description: "City tickets for trips in Vienna", image: nil)
      .previewLayout(.sizeThatFits)
      .preferredColorScheme(.dark)
      .padding()
    
    List {
      ForEach(alphabet, id: \.self) { letter in
        ProductCell(title: String(letter), description: "Color preview", image: nil)
      }
    }
    .listStyle(InsetGroupedListStyle())
  }
}
