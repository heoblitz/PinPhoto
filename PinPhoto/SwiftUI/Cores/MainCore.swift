//
//  MainCore.swift
//  PinPhoto
//
//  Created by woody on 2022/09/12.
//  Copyright © 2022 won heo. All rights reserved.
//

import ComposableArchitecture
import Combine

typealias MainReducer = Reducer<MainState, MainAction, MainEnvironment>

let mainReducer = MainReducer.combine(
  groupReducer.pullback(
    state: \MainState.groupState,
    action: /MainAction.groupActions,
    environment: { $0 }
  ),
  itemReducer.pullback(
    state: \MainState.itemState,
    action: /MainAction.itemActions,
    environment: { $0 }
  ),
  homeReducer.pullback(
    state: \MainState.homeState,
    action: /MainAction.homeActions,
    environment: { $0 }
  ),
  .init { state, action, environment in
    switch action {
    case .sceneWillConnect:
      let fetchGroups = environment
        .groupDataRepository
        .fetchGroups()
        .map { MainAction.groupActions(.groupFetched($0)) }
        .replaceError(with: MainAction.errorOccurred)
        .eraseToEffect()
      
      return fetchGroups
      
    case .groupActions(.groupFetched(let groups)):
      let fetchItemsEffect = environment
        .itemDataRepository
        .fetchItems()
        .map { MainAction.itemActions(.itemFetched($0)) }
        .replaceError(with: MainAction.errorOccurred)
        .eraseToEffect()
      
      let homeGroupFetchedEffect = Just(MainAction.homeActions(.groupFetched(groups)))
        .eraseToEffect()
      
      return .merge(fetchItemsEffect, homeGroupFetchedEffect)
      
    case .itemActions(.itemFetched(let items)):
      let homeGroupFetchedEffect = Just(MainAction.homeActions(.itemFetched(items)))
        .eraseToEffect()
        
      return homeGroupFetchedEffect
    default: break
    }
    
    return .none
  }.debug()
)

struct MainState: Equatable {
  var groupState = GroupState()
  var itemState = ItemState()
  var homeState = HomeState()
}

enum MainAction {
  case sceneWillConnect
  case errorOccurred
  case groupActions(GroupAction)
  case itemActions(ItemAction)
  case homeActions(HomeAction)
}

final class MainEnvironment {
  static let live = MainEnvironment(
    groupDataRepository: GroupDataRepository(),
    itemDataRepository: CoreDataRepository()
  )
  static let mock = MainEnvironment(
    groupDataRepository: MockGroupDataRepository(),
    itemDataRepository: CoreDataRepository()
  )
  
  let groupDataRepository: GroupDataRepositoryProtocol
  let itemDataRepository: CoreDataRepositoryProtocol
  
  init(groupDataRepository: GroupDataRepositoryProtocol, itemDataRepository: CoreDataRepositoryProtocol) {
    self.groupDataRepository = groupDataRepository
    self.itemDataRepository = itemDataRepository
  }
}
