//
//  ItemService.swift
//  PinPhoto
//
//  Created by won heo on 2020/07/15.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit

public class ItemService {
    // deinit 될 때 옵저버 제거해주기. memory leak 제거
    let coreDataRepository = CoreDataRepository.shared
    private(set) var items = [Item]()
    
//    var numberOfImages: Int {
////        var count = 0
////        items.forEach { item in
////            if item.contentType == 0 { count += 1 }
////        }
//        return items.reduce(0, { $0 + Int($1.contentType == 0 ? 1 : 0) })
//    }
    
//    var numberOfItems: Int {
//        return items.count
//    }
    
    var idForAdd: Int64 {
        return Int64(coreDataRepository.itemAddingIdentifier())
    }
    
    var idForInitialize: [Int] {
        return items.map { Int($0.id) }
    }
    
    func item(at index: Int) -> Item {
        return items[index]
    }
    
    func itemFromId(at id: Int) -> Item? {
        return coreDataRepository.getItemFromIds(ids: [id]).first
    }
    
    func thumbnailItem(ids: [Int]) -> Item? {
        return coreDataRepository.thumbnailItem(ids: ids)
    }
    
    func remove(id: Int64) {
        coreDataRepository.removeItem(id: id)
    }
    
    func add(content: Int64, image: Data?, text: String?, date: Date, id: Int64) {
        coreDataRepository.saveItem(
            contentType: content,
            contentImage: image,
            contentText: text,
            updateDate: date, id: id
        )
    }
    
    func edit(content: Int64, image: Data?, text: String?, date: Date, id: Int64) {
        coreDataRepository.editItem(
            contentType: content,
            contentImage: image,
            contentText: text,
            updateDate: date,
            id: id
        )
    }
    
    func fetch() {
        items = coreDataRepository.getItem()
    }
    
    func fetch(by indentifiers: [Int]) {
        items = coreDataRepository.getItemFromIds(ids: indentifiers)
    }
    
    func fetchImages() {
        items = coreDataRepository.getItemImages()
    }
    
    func creationData(date: Date?) -> String? {
        if let date = date {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ko_KR")
            dateFormatter.dateFormat = "YYYY년 MM월 dd일"
            
            return dateFormatter.string(from: date)
        } else {
            return nil
        }
    }
    
    func registerObserver(_ target: ItemObserver) {
        coreDataRepository.addObserver(target)
    }
}
