//
//  ItemViewModel.swift
//  PinPhotoExtension
//
//  Created by won heo on 2020/07/28.
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
        NSLog("%d \n", items.count)
        for item in items {
            print("----->\(item.id)")
            print("----->\(item.contentType)")
            print("----->\(item.contentText ?? "")")
        }
    }
}
