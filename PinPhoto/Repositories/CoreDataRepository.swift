//
//  CoreDataRepository.swift
//  PinPhoto
//
//  Created by woody on 2022/09/12.
//  Copyright © 2022 won heo. All rights reserved.
//

import Foundation
import CoreData
import Combine

protocol CoreDataRepositoryProtocol {
  func save(itemDto: ItemDto) -> AnyPublisher<Item, PinPhotoError>
  func remove(item: Item) -> AnyPublisher<Item, PinPhotoError>
  func edit(item: Item, with itemDto: ItemDto) -> AnyPublisher<Item, PinPhotoError>
  func fetchItems() -> AnyPublisher<[Item], PinPhotoError>
}

final class CoreDataRepository {
  private enum Constant {
    static let fileName = "group.json"
    static let appGroupID = "group.com.wonheo.PinPhoto"
    static let databaseName = "Pin"
    static let idKey = "id"
    static let queue = "coreDataRepository"
  }
    
  private let context: NSManagedObjectContext = {
    let container = NSPersistentContainer(name: Item.Constant.entityName)
    let storeURL = URL.storeURL(for: Constant.appGroupID, databaseName: Constant.appGroupID)
    container.persistentStoreDescriptions = [NSPersistentStoreDescription(url: storeURL)]
    container.loadPersistentStores { storeDescription, error in
      if let error = error {
        assertionFailure(error.localizedDescription)
      }
    }
    let objectContext = container.newBackgroundContext()
    objectContext.automaticallyMergesChangesFromParent = true
    return objectContext
  }()
}

extension CoreDataRepository: CoreDataRepositoryProtocol {
  func save(itemDto: ItemDto) -> AnyPublisher<Item, PinPhotoError> {
    return Deferred { [weak self] in
      Future { [weak self] promise in
        guard let self = self else {
          promise(.failure(.isSelfReleased))
          return
        }

        guard let entity = NSEntityDescription.entity(forEntityName: Item.Constant.entityName, in: self.context) else {
          promise(.failure(.invalid))
          return
        }
        
        guard let item = NSManagedObject(entity: entity, insertInto: self.context) as? Item else {
          promise(.failure(.optionalUnwrappingFailed))
          return
        }
        
        item.contentType = itemDto.contentType
        item.contentImage = itemDto.contentImage
        item.contentText = itemDto.contentText
        item.updateDate = itemDto.updateDate
        item.id = itemDto.id
        
        do {
          try self.context.save()
          promise(.success(item))
        } catch {
          promise(.failure(.saveFailed))
        }
      }
    }.eraseToAnyPublisher()
  }
  
  func edit(item: Item, with itemDto: ItemDto) -> AnyPublisher<Item, PinPhotoError> {
    return Deferred { [weak self] in
      Future { [weak self] promise in
        guard let self = self else {
          promise(.failure(.isSelfReleased))
          return
        }

        do {
          item.contentType = itemDto.contentType
          item.contentImage = itemDto.contentImage
          item.contentText = itemDto.contentText
          item.updateDate = itemDto.updateDate
          
          try self.context.save()
          promise(.success(item))
        } catch _ {
          promise(.failure(.saveFailed))
        }
      }
    }.eraseToAnyPublisher()
  }
  
  func remove(item: Item) -> AnyPublisher<Item, PinPhotoError> {
    return Deferred { [weak self] in
      Future { [weak self] promise in
        guard let self = self else {
          promise(.failure(.isSelfReleased))
          return
        }

        do {
          self.context.delete(item)
          try self.context.save()
          promise(.success(item))
        } catch _ {
          promise(.failure(.saveFailed))
        }
      }
    }.eraseToAnyPublisher()
  }
  
  func fetchItems() -> AnyPublisher<[Item], PinPhotoError> {
    return Deferred { [weak self] in
      Future { [weak self] promise in
        guard let self = self else {
          promise(.failure(.isSelfReleased))
          return
        }

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Item.Constant.entityName)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: Constant.idKey, ascending: true)]
        
        do {
          guard let items = try self.context.fetch(fetchRequest) as? [Item] else {
            promise(.failure(.fetchFailed))
            return
          }
          
          promise(.success(items))
        } catch _ {
          promise(.failure(.fetchFailed))
        }
      }
    }.eraseToAnyPublisher()
  }
  
  fileprivate func filteredRequest(id: Int64) -> NSFetchRequest<NSFetchRequestResult> {
      let fetchRequest: NSFetchRequest<NSFetchRequestResult>
    = NSFetchRequest<NSFetchRequestResult>(entityName: Item.Constant.entityName)
      fetchRequest.predicate = NSPredicate(format: "id = %@", NSNumber(value: id))
      return fetchRequest
  }
}
