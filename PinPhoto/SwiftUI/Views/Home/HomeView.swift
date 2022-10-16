//
//  HomeView.swift
//  PinPhoto
//
//  Created by woody on 2022/03/05.
//  Copyright © 2022 won heo. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct HomeView: View {
  private enum Localized {
    static let item = "Item".localized
  }
  
  private enum Metric {
    static let numberOfColumns = 2.f
    static let columnPadding = 40.f
  }  
  
  private let store: Store<HomeState, HomeAction>
  @ObservedObject private var viewStore: ViewStore<HomeState, HomeAction>
  
  init(store: Store<HomeState, HomeAction>) {
    self.store = store
    self.viewStore = ViewStore(store)
  }
  
  var body: some View {
    WithViewStore(store) { state in
      GeometryReader { proxy in
        let columns: [GridItem] = Array(
          repeating: GridItem(.fixed((proxy.size.width - Metric.columnPadding) / Metric.numberOfColumns)),
          count: Int(Metric.numberOfColumns)
        )
        let height = (proxy.size.width - Metric.columnPadding) / Metric.numberOfColumns
        
        NavigationView {
          ZStack {
            ScrollView(.vertical) {
              NavigationLink(destination: HomeDetailView()) {
                HomeHeaderView()
              }.buttonStyle(ScaleButtonStyle())
              Divider()
              HomeItemHeaderView()
              LazyVGrid(columns: columns) {
                ForEach(state.homeThumbnails, id: \.self) { thumbnail in
                  NavigationLink(destination: HomeDetailView()) {
                    HomeItemView(thumbnail: thumbnail)
                      .frame(minHeight: height, maxHeight: height)
                  }.buttonStyle(ScaleButtonStyle())
                }
              }
            }.navigationTitle(Localized.item).padding([.leading, .trailing])
            VStack {
              Spacer()
              HStack() {
                Spacer()
                HomeAddButtonView()
                  .padding()
              }
            }
          }
        }
        .navigationViewStyle(.stack)
      }
    }
  }
}
