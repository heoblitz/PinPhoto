//
//  ItemDto.swift
//  PinPhoto
//
//  Created by woody on 2022/09/12.
//  Copyright © 2022 won heo. All rights reserved.
//

import Foundation

struct ItemDto {
  let contentType: Int64
  let contentImage: Data?
  let contentText: String?
  let updateDate: Date
  let id: Int64
  
  init(item: Item) {
    self.contentType = item.contentType
    self.contentImage = item.contentImage
    self.contentText = item.contentText
    self.updateDate = item.updateDate
    self.id = item.id
  }
}
