//
//  AppView.swift
//  PinPhoto
//
//  Created by woody on 2022/03/05.
//  Copyright © 2022 won heo. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct AppView: View {
  private enum Constant {
    static let itemImageName = "tray.full.fill"
    static let searchImageName = "magnifyingglass"
    static let groupImageName = "folder.badge.plus"
    static let settingImageName = "gear"
  }
  
  private enum Localized {
    static let item = "Item".localized
    static let search = "Search".localized
    static let group = "Group".localized
    static let setting = "Setting".localized
  }
  
  private let store: Store<AppState, AppAction>
  
  init(store: Store<AppState, AppAction>) {
    self.store = store
  }
  
  var body: some View {
    TabView {
      HomeView(store: store.scope(state: \.home, action: AppAction.homeActions)).tabItem {
        Image(systemName: Constant.itemImageName)
        Text(Localized.item)
      }
      SearchView().tabItem {
        Image(systemName: Constant.searchImageName)
        Text(Localized.search)
      }
      GroupView().tabItem {
        Image(systemName: Constant.groupImageName)
        Text(Localized.group)
      }
      SettingView().tabItem {
        Image(systemName: Constant.settingImageName)
        Text(Localized.setting)
      }
    }.accentColor(.pink)
  }
}

