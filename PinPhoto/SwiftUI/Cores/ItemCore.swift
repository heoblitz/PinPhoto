//
//  ItemCore.swift
//  PinPhoto
//
//  Created by woody on 2022/09/12.
//  Copyright © 2022 won heo. All rights reserved.
//

import ComposableArchitecture

typealias ItemState = ItemReducer.State
typealias ItemAction = ItemReducer.Action

struct ItemReducer: ReducerProtocol {
  struct State: Equatable {
    var items: [Item] = []
  }
  
  enum Action: Equatable {
    case itemFetched([Item])
  }
  
  var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .itemFetched(let items):
        state.items = items
      }
      
      return .none
    }
  }
}
