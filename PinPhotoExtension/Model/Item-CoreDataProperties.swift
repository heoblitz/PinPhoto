//
//  Item-CoreDataProperties.swift
//  PinPhotoExtension
//
//  Created by won heo on 2020/07/28.
//  Copyright © 2020 won heo. All rights reserved.
//

import Foundation
import CoreData

extension Item {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var id: Int64
    @NSManaged public var updateDate: Date
    @NSManaged public var contentType: Int64
    @NSManaged public var contentImage: Data?
    @NSManaged public var contentText: String?
}
