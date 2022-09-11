//
//  Group.swift
//  PinPhoto
//
//  Created by won heo on 2020/09/03.
//  Copyright © 2020 won heo. All rights reserved.
//

import Foundation

struct Group: Codable {
  var sectionName: String
  var ids: [Int]
}

extension Group {
  var id: String { self.sectionName }
  
  var name: String {
    return sectionName
  }
  
  var numberOfItem: Int {
    return ids.count
  }
}

extension Group: Equatable {}

extension Group: Hashable {}
