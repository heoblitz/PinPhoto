//
//  HomeHeaderView.swift
//  PinPhoto
//
//  Created by woody on 2022/03/05.
//  Copyright © 2022 won heo. All rights reserved.
//

import SwiftUI

struct HomeHeaderView: View {
  private enum Style {
    static let placeholderFont = Font.system(size: 24, weight: .bold)
  }
  
  private enum Metrix {
    static let viewCornerRadius = 20.f
  }
  
  var body: some View {
    ZStack(alignment: .bottomLeading) {
      Image("widgetImage")
        .resizable()
        .aspectRatio(contentMode: .fit)
      Text("위젯에 표시될 항목")
        .font(Style.placeholderFont)
        .foregroundColor(.white)
        .padding()
    }
    .cornerRadius(Metrix.viewCornerRadius)
  }
}

struct HomeHeaderView_Previews: PreviewProvider {
  static var previews: some View {
    HomeHeaderView()
  }
}
