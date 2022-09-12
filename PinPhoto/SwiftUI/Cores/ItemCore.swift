//
//  ItemCore.swift
//  PinPhoto
//
//  Created by woody on 2022/09/12.
//  Copyright © 2022 won heo. All rights reserved.
//

import ComposableArchitecture

typealias ItemReducer = Reducer<ItemState, ItemAction, MainEnvironment>

let itemReducer = ItemReducer.init { state, action, _ in
  switch action {
  case .itemFetched(let items):
    state.items = items
  }
  
  return .none
}

struct ItemState: Equatable {
  var items: [Item] = []
}

enum ItemAction {
  case itemFetched([Item])
}
