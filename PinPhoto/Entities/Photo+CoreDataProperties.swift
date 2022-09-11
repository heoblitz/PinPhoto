//
//  Photo+CoreDataProperties.swift
//  
//
//  Created by won heo on 2020/07/12.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var contentType: Int64
    @NSManaged public var contentImage: Data?
    @NSManaged public var contentText: String?
    @NSManaged public var updateDate: Date?
    @NSManaged public var id: [String]?

}
