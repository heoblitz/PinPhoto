//
//  HomeAddButtonView.swift
//  PinPhoto
//
//  Created by woody on 2022/03/05.
//  Copyright © 2022 won heo. All rights reserved.
//

import SwiftUI

struct HomeAddButtonView: View {
  private enum Constant {
    static let plusImageName = "plus"
  }
  
  private enum Metrix {
    static let plusImageLength = 20.f
    static let plusButtonLength = 50.f
    static let viewCornerRadius = 25.f
  }
  
  var body: some View {
    ZStack {
      Image(systemName: Constant.plusImageName)
        .resizable()
        .frame(width: Metrix.plusImageLength, height: Metrix.plusImageLength, alignment: .center)
        .foregroundColor(.white)
    }
    .frame(width: Metrix.plusButtonLength, height: Metrix.plusButtonLength)
    .background(.pink)
    .cornerRadius(Metrix.viewCornerRadius)
  }
}

struct HomeAddButtonView_Previews: PreviewProvider {
  static var previews: some View {
    HomeAddButtonView()
  }
}
