//
//  HomeItemHeaderView.swift
//  PinPhoto
//
//  Created by woody on 2022/03/05.
//  Copyright © 2022 won heo. All rights reserved.
//

import SwiftUI

struct HomeItemHeaderView: View {
  private enum Style {
    static let titleFont = Font.system(size: 18, weight: .medium)
    static let titleColor = Color.gray
  }
  
  private enum Localized {
    static let group = "Group".localized
  }
  
  var body: some View {
    HStack {
      Text(Localized.group)
        .font(Style.titleFont)
        .foregroundColor(Style.titleColor)
      Spacer()
    }
  }
}

struct HomeItemHeaderView_Previews: PreviewProvider {
  static var previews: some View {
    HomeItemHeaderView()
  }
}
