//
//  HomeItemView.swift
//  PinPhoto
//
//  Created by woody on 2022/03/05.
//  Copyright © 2022 won heo. All rights reserved.
//

import SwiftUI

struct HomeItemView: View {
  private enum Style {
    static let titleFont = Font.system(size: 24, weight: .bold)
    static let placeholderFont = Font.system(size: 17, weight: .medium)
  }
  
  private enum Metrix {
    static let viewCornerRadius = 10.f
  }
  
  var body: some View {
      ZStack {
        Text("Please Add Items".localized)
          .font(Style.placeholderFont)
          .foregroundColor(.white)
        VStack {
          Spacer()
          HStack() {
            Text("안녕")
              .font(Style.titleFont)
              .foregroundColor(.white)
              .padding()
            Spacer()
          }
        }
      }
      .background(.gray)
      .cornerRadius(Metrix.viewCornerRadius)
  }
}

struct HomeItemView_Previews: PreviewProvider {
  static var previews: some View {
    HomeItemView()
      .previewLayout(.fixed(width: 200, height: 200))
  }
}
