//
//  Item+CoreDataProperties.swift
//  
//
//  Created by won heo on 2020/07/12.
//
//

import Foundation
import CoreData

public enum ItemType: CaseIterable {
    case image
    case text
    
    var value: Int64 {
        switch self {
        case .image:
            return 0
        case .text:
            return 1
        }
    }
    
    var title: String {
        switch self {
        case .image:
            return "Add Image".localized
        case .text:
            return "Add Text".localized
        }
    }
}

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

