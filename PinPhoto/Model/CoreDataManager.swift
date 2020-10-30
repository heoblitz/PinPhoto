//
//  CoreDataManager.swift
//  PinPhoto
//
//  Created by won heo on 2020/07/12.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit
import CoreData

public class CoreDataManager {
    // MARK:- Propertises
    static let shared: CoreDataManager = CoreDataManager()

    private lazy var context = persistentContainer.viewContext
    // private let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    private let modelName: String = "Item"
    
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Item")
        let storeURL = URL.storeURL(for: "group.com.wonheo.PinPhoto", databaseName: "Pin")
        container.persistentStoreDescriptions = [NSPersistentStoreDescription(url: storeURL)]
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        print(storeURL)
        return container
    }()
    
    var itemObservers: [ItemObserver] = []
    
    // MARK:- Methods
    func getItem() -> [Item] {
        var models: [Item] = []
        
        let idSort = NSSortDescriptor(key: "id", ascending: true)
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
    
    func getItemFromIds(ids: [Int]) -> [Item] {
        var models: [Item] = []
        
        let newids: [NSNumber] = ids.map { return NSNumber(value: $0) }
        let idSort = NSSortDescriptor(key: "id", ascending: true)
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: modelName)

        fetchRequest.sortDescriptors = [idSort]
        fetchRequest.predicate = NSPredicate(format: "id IN %@", newids)
        
        do {
            if let fetchResult = try context.fetch(fetchRequest) as? [Item] {
                models = fetchResult
            }
        } catch let error as NSError {
            print("---> could not getItem \(error)")
            self.noticeError(error)
        }
        
        return models
    }
    
    func thumbnailItem(ids: [Int]) -> Item? {
        let idSort = NSSortDescriptor(key: "id", ascending: false)
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: modelName)

        fetchRequest.sortDescriptors = [idSort]
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "id IN %@", ids)
        // 이미지 데이터만 Fetch 하기
        // fetchRequest.predicate = NSPredicate(format: "id IN %@ AND contentType == 0", ids)
        
        do {
            if let fetchResult = try context.fetch(fetchRequest) as? [Item] {
                return fetchResult.first
            }
        } catch let error as NSError {
            print("---> could not fetch \(error)")
            self.noticeError(error)
        }
        
        return nil
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
            print("---> could not remove \(error) \(error.userInfo)")
            self.noticeError(error)
        }
        
        contextSave { success in
            print("---> CoreData remove \(success)")
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
    
    func getItemCount() -> Int {
        let idSort = NSSortDescriptor(key: "id", ascending: false)
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: modelName)
        
        fetchRequest.sortDescriptors = [idSort]
        fetchRequest.fetchLimit = 1
        
        do {
            if let fetchResult = try context.fetch(fetchRequest) as? [Item], let id = fetchResult.first?.id  {
                return Int(id + 1)
            }
        } catch let error as NSError {
            print("could not fetch \(error) \(error.userInfo)")
            self.noticeError(error)
        }
        
        return 0
    }
    
    func destructive() {
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
            print("Could not save: \(error), \(error.userInfo)")
            onSuccess(false)
        }
    }
}
