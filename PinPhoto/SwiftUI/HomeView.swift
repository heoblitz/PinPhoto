//
//  HomeView.swift
//  PinPhoto
//
//  Created by woody on 2022/03/05.
//  Copyright © 2022 won heo. All rights reserved.
//

import SwiftUI

struct HomeView: View {
  private enum Localized {
    static let item = "Item".localized
  }
  
  var body: some View {
    NavigationView {
      NavigationLink(destination: Text("text")) {
        Text("text")
      }.navigationTitle(Localized.item)
    }
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
  }
}
