//
//  GroupCore.swift
//  PinPhoto
//
//  Created by woody on 2022/09/12.
//  Copyright © 2022 won heo. All rights reserved.
//

import ComposableArchitecture

typealias GroupReducer = Reducer<GroupState, GroupAction, MainEnvironment>

let groupReducer = GroupReducer.init { _, _, _ in
  return .none
}

struct GroupState: Equatable {
  var groups: [Group] = []
  var thumbnails: [String: Item] = [:]
}

enum GroupAction {
  case groupFetched
}
