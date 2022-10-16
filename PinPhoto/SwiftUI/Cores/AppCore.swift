//
//  AppCore.swift
//  PinPhoto
//
//  Created by woody on 2022/09/12.
//  Copyright © 2022 won heo. All rights reserved.
//

import ComposableArchitecture
import Combine

typealias AppState = AppReducer.State
typealias AppAction = AppReducer.Action

struct AppReducer: ReducerProtocol {
  struct State: Equatable {
    var group = GroupReducer.State()
    var item = ItemReducer.State()
    var home = HomeReducer.State()
  }
  
  enum Action: Equatable {
    case sceneWillConnect
    case errorOccurred
    case groupActions(GroupReducer.Action)
    case itemActions(ItemReducer.Action)
    case homeActions(HomeReducer.Action)
  }
  
  @Dependency(\.appEnvironment) var appEnvironment
  
  var body: some ReducerProtocol<State, Action> {
    Scope(state: \.item, action: /Action.itemActions) {
      ItemReducer()
    }
    Scope(state: \.group, action: /Action.groupActions) {
      GroupReducer()
    }
    Scope(state: \.home, action: /Action.homeActions) {
      HomeReducer()
    }
    Reduce { state, action in
      switch action {
      case .sceneWillConnect:
        let fetchGroups = appEnvironment
          .groupDataRepository
          .fetchGroups()
          .map { Action.groupActions(.groupFetched($0)) }
          .replaceError(with: Action.errorOccurred)
          .eraseToEffect()

        return fetchGroups

      case .groupActions(.groupFetched(let groups)):
        let fetchItemsEffect = appEnvironment
          .itemDataRepository
          .fetchItems()
          .map { Action.itemActions(.itemFetched($0)) }
          .replaceError(with: Action.errorOccurred)
          .eraseToEffect()

        let homeGroupFetchedEffect = Just(Action.homeActions(.groupFetched(groups)))
          .eraseToEffect()

        return .merge(fetchItemsEffect, homeGroupFetchedEffect)

      case .itemActions(.itemFetched(let items)):
        let homeGroupFetchedEffect = Just(Action.homeActions(.itemFetched(items)))
          .eraseToEffect()

        return homeGroupFetchedEffect
      default: break
      }

      return .none
    }
  }
}

final class AppEnvironment: TestDependencyKey {
  static let previewValue = AppEnvironment(
    groupDataRepository: MockGroupDataRepository(), // GroupDataRepository(),
    itemDataRepository: CoreDataRepository()
  )
  static let testValue = AppEnvironment(
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

extension DependencyValues {
  var appEnvironment: AppEnvironment {
    get { self[AppEnvironment.self] }
    set { self[AppEnvironment.self] = newValue }
  }
}
