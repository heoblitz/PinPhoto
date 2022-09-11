//
//  Item+CoreDataClass.swift
//  
//
//  Created by won heo on 2020/07/12.
//
//

import Foundation
import CoreData

@objc(Item)
public class Item: NSManagedObject {
  enum Constant {
    static let entityName = "Item"
  }
}

extension Item {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
    return NSFetchRequest<Item>(entityName: Item.Constant.entityName)
  }
  
  @NSManaged public var id: Int64
  @NSManaged public var updateDate: Date
  @NSManaged public var contentType: Int64
  @NSManaged public var contentImage: Data?
  @NSManaged public var contentText: String?
  
  var type: ItemType {
    guard let type = ItemType(rawValue: Int(self.contentType)) else {
      assertionFailure("type should not nil")
      return .text
    }
    
    return type
  }
}
