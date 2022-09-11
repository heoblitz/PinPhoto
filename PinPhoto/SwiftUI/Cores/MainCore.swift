//
//  MainCore.swift
//  PinPhoto
//
//  Created by woody on 2022/09/12.
//  Copyright © 2022 won heo. All rights reserved.
//

import ComposableArchitecture

typealias MainReducer = Reducer<MainState, MainAction, MainEnvironment>

let mainReducer = MainReducer.combine(
  groupReducer.pullback(
    state: \MainState.groupState,
    action: /MainAction.groupActions,
    environment: { $0 }
  ),
  .init { state, action, environment in
    switch action {
    case .sceneWillConnect:
      return environment
        .groupDataRepository
        .fetchGroups()
        .map { MainAction.groupActions(.groupFetched($0)) }
        .replaceError(with: MainAction.errorOccurred)
        .eraseToEffect()
    default:
      break
    }
    
    return .none
  }
)

struct MainState: Equatable {
  var groupState: GroupState = GroupState()
}

enum MainAction {
  case sceneWillConnect
  case errorOccurred
  case groupActions(GroupAction)
}

final class MainEnvironment {
  static let live = MainEnvironment(groupDataRepository: GroupDataRepository())
  static let mock = MainEnvironment(groupDataRepository: MockGroupDataRepository())
  
  let groupDataRepository: GroupDataRepositoryProtocol
  
  init(groupDataRepository: GroupDataRepositoryProtocol) {
    self.groupDataRepository = groupDataRepository
  }
}
