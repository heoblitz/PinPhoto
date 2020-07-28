//
//  Item.swift
//  PinPhotoExtension
//
//  Created by won heo on 2020/07/28.
//  Copyright © 2020 won heo. All rights reserved.
//

import Foundation
import CoreData

class Item: NSManagedObject {
    var id: Int64 = 0
    var updateDate: Date = Date()
    var contentType: Int64 = 0
    var contentImage: Data?
    var contentText: String?
}
