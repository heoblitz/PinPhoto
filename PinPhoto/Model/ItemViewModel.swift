//
//  ItemViewModel.swift
//  PinPhoto
//
//  Created by won heo on 2020/07/15.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit

class ItemViewModel {
    let shared: CoreDataManager = CoreDataManager()
    var items: [Item] = []
    
    var numberOfItems: Int {
        return items.count
    }
    
    var idForAdd: Int64 {
        return Int64(items.count)
    }
    
    func item(at index: Int) -> Item {
        return items[index]
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
    
    func convertImageToData(image: UIImage?) -> Data? {
        guard let image = image else {
            return nil
        }
        return image.pngData()
    }
    
    func convertDataToImage(data: Data?) -> UIImage? {
        guard let data = data else {
            return nil
        }
        return UIImage(data: data)
    }
    
    func loadItems() {
        items = shared.getItem()
        items.reverse()
    }
    
    func printID() {
        print("\(items.count)")
        for item in items {
            print("----->\(item.id)")
            print("----->\(item.contentType)")
            print("----->\(item.contentText ?? "")")
        }
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
