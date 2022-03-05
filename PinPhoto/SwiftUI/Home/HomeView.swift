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
  
  private enum Metric {
  }
  
  let items: [String] = (1...20).map { String($0) }
  
  var body: some View {
    GeometryReader { g in
      let columns: [GridItem] = Array(repeating: GridItem(.fixed((g.size.width - 40) / 2)), count: 2)
      let height = (g.size.width - 40) / 2
       
      NavigationView {
        ZStack {
          ScrollView(.vertical) {
            NavigationLink(destination: HomeDetailView()) {
              HomeHeaderView()
            }.buttonStyle(ScaleButtonStyle())
            Divider()
            HomeItemHeaderView()
            LazyVGrid(columns: columns) {
              ForEach(self.items, id: \.self) { _ in
                HomeItemView().frame(minHeight: height, maxHeight: height)
              }
            }
          }.navigationTitle(Localized.item).padding([.leading, .trailing])
          VStack {
            Spacer()
            HStack() {
              Spacer()
              HomeAddButtonView()
                .padding()
                .onTapGesture {
                  
                }
            }
          }
        }
      }
      .navigationViewStyle(.stack)
    }
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
  }
}
