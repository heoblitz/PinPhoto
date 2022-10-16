//
//  HomeCore.swift
//  PinPhoto
//
//  Created by woody on 2022/09/12.
//  Copyright © 2022 won heo. All rights reserved.
//

import ComposableArchitecture

typealias HomeState = HomeReducer.State
typealias HomeAction = HomeReducer.Action

struct HomeReducer: ReducerProtocol {
  struct State: Equatable {
    var groups: [Group] = []
    var items: [Item] = []
  }
  
  enum Action: Equatable { }
  
  var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      return .none
    }
  }
}

struct HomeThumbnail: Equatable, Hashable {
  var group: Group
  var item: Item?
  
  func mutateItem(with item: Item?) -> HomeThumbnail {
    return Self(group: self.group, item: item)
  }
}
