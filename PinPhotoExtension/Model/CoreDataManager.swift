//
//  CoreDataManager.swift
//  PinPhotoExtension
//
//  Created by won heo on 2020/07/28.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager {
    // MARK:- Propertises
    static let shared: CoreDataManager = CoreDataManager()
    let modelName: String = "Item"

    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Item")
        let storeURL = URL.storeURL(for: "group.com.wonheo.PinPhoto", databaseName: "Pin")
        container.persistentStoreDescriptions = [NSPersistentStoreDescription(url: storeURL)]
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    lazy var context = persistentContainer.viewContext
    
    // MARK:- Methods
    func getItem() -> [Item] {
        var models: [Item] = []
        
        let idSort = NSSortDescriptor(key: "updateDate", ascending: false)
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: modelName)
        
        fetchRequest.sortDescriptors = [idSort]
        
        do {
            if let fetchResult = try context.fetch(fetchRequest) as? [Item] {
                models = fetchResult
            }
        } catch let error as NSError {
            print("---> getItem")
            print("could not fetch \(error) \(error.userInfo)")
        }
        
        return models
    }
}

public extension URL {
    static func storeURL(for appGroup: String, databaseName: String) -> URL {
        guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            fatalError("Shared file container could not be created.")
        }

        return fileContainer.appendingPathComponent("\(databaseName).sqlite")
    }
}
