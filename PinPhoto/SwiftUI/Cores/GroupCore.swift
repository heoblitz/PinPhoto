//
//  GroupCore.swift
//  PinPhoto
//
//  Created by woody on 2022/09/12.
//  Copyright © 2022 won heo. All rights reserved.
//

import ComposableArchitecture

typealias GroupState = GroupReducer.State
typealias GroupAction = GroupReducer.Action

struct GroupReducer: ReducerProtocol {
  struct State: Equatable {
    var groups: [Group] = []
  }
  
  enum Action: Equatable {
    case groupFetched([Group])
  }
  
  var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .groupFetched(let groups):
        state.groups = groups
      }
      
      return .none
    }
  }
}
