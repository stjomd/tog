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
  
  private var circleColorComponents: (red: Double, green: Double, blue: Double) {
    let value = Double(title.first?.asciiValue ?? 15)
    let red   = sin(value) * sin(value)
    let green = 0.5 + sin(value) * cos(value)
    let blue  = cos(value) * cos(value)
    return (red: red, green: green, blue: blue)
  }
  private var circleColor: Color {
    let (red, green, blue) = circleColorComponents
    return Color(red: red, green: green, blue: blue)
  }
  private var circleTextColor: Color {
    let (red, green, blue) = circleColorComponents
    if 0.299*red + 0.587*green + 0.114*blue > 186/255 {
      return .black
    } else {
      return .white
    }
  }
  
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
