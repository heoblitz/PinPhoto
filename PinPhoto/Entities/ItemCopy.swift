//
//  ItemCopy.swift
//  PinPhoto
//
//  Created by won heo on 2020/09/16.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit

public struct ItemCopy {
    let id: Int64
    let updateDate: Date
    let contentType: Int64
    let contentImage: Data?
    let contentText: String?
    
    init(item: Item) {
        self.id = item.id
        self.updateDate = item.updateDate
        self.contentType = item.contentType
        self.contentImage = item.contentImage
        self.contentText = item.contentText
    }
}
