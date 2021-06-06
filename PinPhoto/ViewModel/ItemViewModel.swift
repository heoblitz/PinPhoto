//
//  ItemViewModel.swift
//  PinPhoto
//
//  Created by won heo on 2020/07/15.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit

public class ItemViewModel {
    // deinit 될 때 옵저버 제거해주기. memory leak 제거
    let shared: CoreDataManager = CoreDataManager.shared
    private(set) var items: [Item] = []
    
    var numberOfImages: Int {
        var count = 0
        items.forEach { item in
            if item.contentType == 0 { count += 1 }
        }
        return count
    }
    
    var numberOfItems: Int {
        return items.count
    }
    
    var idForAdd: Int64 {
        return Int64(shared.getItemCount())
    }
    
    var idForInitialize: [Int] {
        return items.map { Int($0.id) }
    }
    
    func item(at index: Int) -> Item {
        return items[index]
    }

    func itemFromId(at id: Int) -> Item? {
        return shared.getItemFromIds(ids: [id]).first
    }
 
    func thumbnailItem(ids: [Int]) -> Item? {
        return shared.thumbnailItem(ids: ids)
    }

    func remove(id: Int64) {
        shared.removeItem(id: id)
    }

    func add(content: Int64, image: Data?, text: String?, date: Date, id: Int64) {
        shared.saveItem(contentType: content, contentImage: image, contentText: text, updateDate: date, id: id)
    }
    
    func edit(content: Int64, image: Data?, text: String?, date: Date, id: Int64) {
        shared.editItem(contentType: content, contentImage: image, contentText: text, updateDate: date, id: id)
    }
    
    func load() {
        items = shared.getItem()
    }
    
    func loadFromIds(ids: [Int]) {
        items = shared.getItemFromIds(ids: ids)
    }
    
    func loadItemImages() {
        items = shared.getItemImages()
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
        shared.addObserver(target)
    }
}
