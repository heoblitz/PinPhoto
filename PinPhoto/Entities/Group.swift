//
//  Group.swift
//  PinPhoto
//
//  Created by won heo on 2020/09/03.
//  Copyright © 2020 won heo. All rights reserved.
//

import Foundation

struct Group: Codable {
  var id = UUID()
  var sectionName: String
  var ids: [Int]
}

extension Group {
  var name: String { sectionName }
  
  var numberOfItem: Int { ids.count }
  
  var isHeaderGroup: Bool { sectionName == "위젯에 표시될 항목".localized }
}

extension Group: Equatable {}

extension Group: Hashable {}
