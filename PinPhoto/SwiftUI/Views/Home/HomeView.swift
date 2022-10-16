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
  
  private struct ViewState: Equatable {
    var thumbnails: [HomeThumbnail]
    
    init(_ homeState: HomeState) {
      let homeThumbnails = homeState.groups.map { HomeThumbnail(group: $0, item: nil) }
      let itemIds = homeThumbnails.map { $0.group.ids.first }
      let thumbnailItems: [Item?] = itemIds.map { id in
        guard let id = id else { return nil }
        
        return homeState.items.first { $0.id == id }
      }
      
      let newThumbnails = zip(
        homeThumbnails,
        thumbnailItems
      ).map { thumbnail, item in
        thumbnail.mutateItem(with: item)
      }
      
      self.thumbnails = newThumbnails
    }
  }

  private let store: Store<HomeState, HomeAction>
  @ObservedObject private var viewStore: ViewStore<ViewState, HomeAction>
  
  init(store: Store<HomeState, HomeAction>) {
    self.store = store
    self.viewStore = ViewStore(store, observe: ViewState.init)
  }
  
  var body: some View {
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
              ForEach(viewStore.thumbnails, id: \.self) { thumbnail in
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
      }.navigationViewStyle(.stack)
    }
  }
}
