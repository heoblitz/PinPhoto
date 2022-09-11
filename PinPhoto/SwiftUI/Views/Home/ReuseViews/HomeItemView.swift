//
//  HomeItemView.swift
//  PinPhoto
//
//  Created by woody on 2022/03/05.
//  Copyright © 2022 won heo. All rights reserved.
//

import SwiftUI

struct HomeItemView: View {
  private enum Localized {
    static let addItem = "Please Add Items".localized
  }
  
  private enum Style {
    static let titleFont = Font.system(size: 20, weight: .bold)
    static let placeholderFont = Font.system(size: 17, weight: .medium)
  }
  
  private enum Metrix {
    static let viewCornerRadius = 10.f
  }
  
  private let group: Group
  
  init(group: Group) {
    self.group = group
  }
  
  var body: some View {
      ZStack {
        if self.group.ids.isEmpty {
          Text(Localized.addItem)
            .font(Style.placeholderFont)
            .foregroundColor(.white)
        }
        VStack {
          Spacer()
          HStack() {
            Text(self.group.sectionName)
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
