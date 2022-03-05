//
//  MainView.swift
//  PinPhoto
//
//  Created by woody on 2022/03/05.
//  Copyright © 2022 won heo. All rights reserved.
//

import SwiftUI

struct MainView: View {
  private enum Constant {
    static let itemImageName = "house.fill"
  }
  
  private enum Localized {
    static let item = "Item".localized
  }
  
  init() {
    UITabBar.appearance().barTintColor = .systemPink
    UITabBar.appearance().tintColor = .systemPink
  }
  
  var body: some View {
    TabView {
      HomeView().tabItem {
        Image(systemName: Constant.itemImageName)
        Text(Localized.item)
      }
    }.accentColor(.pink)
  }
}

struct MainView_Previews: PreviewProvider {
  static var previews: some View {
    MainView()
  }
}
