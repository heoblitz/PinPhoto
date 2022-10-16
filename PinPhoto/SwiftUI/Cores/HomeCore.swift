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
    var homeThumbnails: [HomeThumbnail] = []
  }
  
  enum Action: Equatable {
    case groupFetched([Group])
    case itemFetched([Item])
  }
  
  var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .groupFetched(let groups):
        state.homeThumbnails = groups.map { HomeThumbnail(group: $0, item: nil) }
      case .itemFetched(let items):
        let itemIds = state.homeThumbnails.map {
          $0.group.ids.first
        }
        
        let thumbnailItems = itemIds.map { id -> Item? in
          guard let id = id else { return nil }
          
          return items.first { $0.id == id }
        }
        
        let newThumbnails = zip(
          state.homeThumbnails,
          thumbnailItems
        )
          .map { thumbnail, item in
            thumbnail.mutateItem(with: item)
          }
        
        state.homeThumbnails = newThumbnails
      }
      
      return .none
    }
  }
}

struct HomeThumbnail: Equatable {
  var group: Group
  var item: Item?
  
  func mutateItem(with item: Item?) -> HomeThumbnail {
    return Self(group: self.group, item: item)
  }
}

extension HomeThumbnail: Hashable {}
