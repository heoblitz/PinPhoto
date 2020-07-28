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
    static let shared: CoreDataManager = CoreDataManager()
    
    let modelName: String = "Item"

    // new code
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Item")
        let storeURL = URL.storeURL(for: "group.com.wonheo.PinPhoto", databaseName: "Pin")
        container.persistentStoreDescriptions = [NSPersistentStoreDescription(url: storeURL)]
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    lazy var context = persistentContainer.viewContext
    
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

//extension CoreDataManager {
//    fileprivate func filteredRequest(id: Int64) -> NSFetchRequest<NSFetchRequestResult> {
//        let fetchRequest: NSFetchRequest<NSFetchRequestResult>
//            = NSFetchRequest<NSFetchRequestResult>(entityName: modelName)
//        fetchRequest.predicate = NSPredicate(format: "id = %@", NSNumber(value: id))
//        return fetchRequest
//    }
//
//    fileprivate func contextSave(onSuccess: ((Bool) -> Void)) {
//        do {
//            try context.save()
//            onSuccess(true)
//        } catch let error as NSError {
//            print("Could not save🥶: \(error), \(error.userInfo)")
//            onSuccess(false)
//        }
//    }
//}

public extension URL {
    /// Returns a URL for the given app group and database pointing to the sqlite database.
    static func storeURL(for appGroup: String, databaseName: String) -> URL {
        guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            fatalError("Shared file container could not be created.")
        }

        return fileContainer.appendingPathComponent("\(databaseName).sqlite")
    }
}
