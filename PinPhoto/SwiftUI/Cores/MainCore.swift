//
//  MainCore.swift
//  PinPhoto
//
//  Created by woody on 2022/09/12.
//  Copyright © 2022 won heo. All rights reserved.
//

import ComposableArchitecture

typealias MainReducer = Reducer<MainState, MainAction, MainEnvironment>

let mainReducer = MainReducer.init { _, _, _ in
  return .none
}

let mainStore = Store<MainState, MainAction>(
  initialState: .init(),
  reducer: mainReducer,
  environment: .mock
)

struct MainState: Equatable {
 
}

enum MainAction {
  case sceneWillConnect
}

final class MainEnvironment {
  static let live = MainEnvironment(groupDataRepository: GroupDataRepository())
  static let mock = MainEnvironment(groupDataRepository: MockGroupDataRepository())
  
  private let groupDataRepository: GroupDataRepositoryProtocol
  
  init(groupDataRepository: GroupDataRepositoryProtocol) {
    self.groupDataRepository = groupDataRepository
  }
}
