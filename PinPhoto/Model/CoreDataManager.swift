//
//  CoreDataManager.swift
//  PinPhoto
//
//  Created by won heo on 2020/07/12.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager {
    // MARK:- Propertises
    static let shared: CoreDataManager = CoreDataManager()
    var itemObservers: [ItemObserver] = []
    
    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    let modelName: String = "Item"
    
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
    
    // MARK:- Initializer
    private init() {
    }
    
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
            self.noticeError(error)
        }
        
        return models
    }
    
    func saveItem(contentType: Int64, contentImage: Data?,
                  contentText: String?, updateDate: Date, id: Int64) {
        guard let entity = NSEntityDescription.entity(forEntityName: modelName, in: context) else {
            return
        }
        
        if let item: Item = NSManagedObject(entity: entity, insertInto: context) as? Item {
            item.contentType = contentType
            item.contentImage = contentImage
            item.contentText = contentText
            item.updateDate = updateDate
            item.id = id
        
            contextSave { success in
                print("---> CoreData save \(success)")
                self.noticeUpdate()
            }
        }
    }
    
    func removeItem(id: Int64) {
        let fetchRequest = filteredRequest(id: id)
        
        do {
            if let results: [Item] = try context.fetch(fetchRequest) as? [Item] {
                if results.count != 0 {
                    context.delete(results[0])
                }
            }
        } catch let error as NSError {
            print("could not fetch \(error) \(error.userInfo)")
            self.noticeError(error)
        }
        
        contextSave { success in
            print("---> coreData remove \(success)")
            self.noticeUpdate()
        }
    }
    
    func editItem(contentType: Int64, contentImage: Data?,
                  contentText: String?, updateDate: Date, id: Int64) {
        let fetchRequest = filteredRequest(id: id)
        
        do {
            if let results: [Item] = try context.fetch(fetchRequest) as? [Item] {
                if results.count != 0 {
                    results[0].setValue(contentType, forKey: "contentType")
                    results[0].setValue(contentImage, forKey: "contentImage")
                    results[0].setValue(contentText, forKey: "contentText")
                    results[0].setValue(updateDate, forKey: "updateDate")
                }
            }
        } catch let error as NSError {
            print("could not fetch \(error) \(error.userInfo)")
            self.noticeError(error)
        }
        
        contextSave { success in
            print("---> coreData edit \(success)")
            self.noticeUpdate()
        }
    }
    
    func destructiveAllItem() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: modelName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            try context.save()
            self.noticeUpdate()
        } catch let error as NSError {
            print("---> destructiveAllItem")
            print("could not excute \(error) \(error.userInfo)")
            self.noticeError(error)
        }
    }
    
    func addObserver(_ target: ItemObserver) {
        itemObservers.append(target)
    }
    
    func noticeUpdate() {
        print("update")
        for observer in itemObservers {
            print(observer)
            observer.updateItem()
        }
    }
    
    func noticeError(_ error: Error) {
        for observer in itemObservers {
            observer.errorItem(error)
        }
    }
}

extension CoreDataManager {
    fileprivate func filteredRequest(id: Int64) -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult>
            = NSFetchRequest<NSFetchRequestResult>(entityName: modelName)
        fetchRequest.predicate = NSPredicate(format: "id = %@", NSNumber(value: id))
        return fetchRequest
    }
    
    fileprivate func contextSave(onSuccess: ((Bool) -> Void)) {
        do {
            try context.save()
            onSuccess(true)
        } catch let error as NSError {
            print("Could not save🥶: \(error), \(error.userInfo)")
            onSuccess(false)
        }
    }
}
