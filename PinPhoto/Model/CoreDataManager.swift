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
    static let shared: CoreDataManager = CoreDataManager()
    
    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    lazy var context = appDelegate?.persistentContainer.viewContext
    
    let modelName: String = "Item"
    
    func getItem() -> [Item] {
        var models: [Item] = []
        
        guard let context = context else {
            return models
        }
        
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
    
    func saveItem(contentType: Int64, contentImage: Data?,
                  contentText: String?, updateDate: Date, id: Int64) {
        // id: [String]?
        guard let context = context else {
            return
        }
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
                print("---> saveItem")
                print(success)
            }
        }
    }
    
    func removeItem(id: Int64) {
        let fetchRequest = filteredRequest(id: id)
        
        do {
            if let results: [Item] = try context?.fetch(fetchRequest) as? [Item] {
                if results.count != 0 {
                    context?.delete(results[0])
                }
            }
        } catch let error as NSError {
            print("could not fetch \(error) \(error.userInfo)")
        }
        
        contextSave { success in
            print("---> coreData remove \(success)")
        }
    }
    
    func destructiveAllItem() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: modelName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context?.execute(deleteRequest)
            try context?.save()
        } catch let error as NSError {
             print("---> destructiveAllItem")
            print("could not excute \(error) \(error.userInfo)")
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
            try context?.save()
            onSuccess(true)
        } catch let error as NSError {
            print("Could not save🥶: \(error), \(error.userInfo)")
            onSuccess(false)
        }
    }
}
