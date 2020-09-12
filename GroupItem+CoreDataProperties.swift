//
//  GroupItem+CoreDataProperties.swift
//  PinPhoto
//
//  Created by won heo on 2020/09/12.
//  Copyright © 2020 won heo. All rights reserved.
//
//

import Foundation
import CoreData


extension GroupItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GroupItem> {
        return NSFetchRequest<GroupItem>(entityName: "GroupItem")
    }

    @NSManaged public var contentImage: Data?
    @NSManaged public var contentText: String?
    @NSManaged public var contentType: Int64
    @NSManaged public var id: Int64
    @NSManaged public var updateDate: Date?

}
