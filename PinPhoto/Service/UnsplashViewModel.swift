//
//  UnsplashViewModel.swift
//  PinPhoto
//
//  Created by heo on 2020/12/21.
//  Copyright © 2020 won heo. All rights reserved.
//

import Foundation
import Kingfisher

final class UnsplashViewModel {
    private let imageCache: ImageCache = ImageCache.default
    let unsplash: Observable<[Unsplash]> = Observable([])
    let coreMLManager: CoreMLManager = CoreMLManager()
    
    var query: String?
    
    init() {}
    
    func requestItems() {
        Api.shared.request(for: query) { unsplashes in
            OperationQueue.main.addOperation {
                self.unsplash.value = unsplashes
            }
        }
    }
    
    func downloadImage(url: URL?) {
        guard let url = url else { return }
                
        do {
            let data = try Data(contentsOf: url)
            
            if let image = UIImage(data: data) {
                imageCache.store(image, forKey: url.absoluteString)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func downloadInitialImages(query: String?, completeHandler: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        let downloadImageQueue = DispatchQueue(label: "downloadImage", attributes: .concurrent)
        
        Api.shared.request(for: query) { unsplashes in
            for unsplash in unsplashes {
                let absoluteString = unsplash.thumnail.small
                let url = URL(string: absoluteString)
                
                downloadImageQueue.async(group: dispatchGroup, execute: {
                    self.downloadImage(url: url)
                })
            }
            
            dispatchGroup.notify(queue: downloadImageQueue, execute: {
                OperationQueue.main.addOperation {
                    completeHandler()
                }
            })
        }
    }
    
    func requestSuggestClassification(completeHandler: @escaping () -> ()) {
        let itemService = ItemService()
        
        itemService.fetchImages()
        
        let images = itemService.items.compactMap { $0.contentImage?.image }
        coreMLManager.requestClassifications(for: images, completeHandler: { classification in
            
            if classification.count > 0 {
                let order = classification.sorted(by: { $0.1 > $1.1 })
                self.query = order.first?.key
            }
            
            self.downloadInitialImages(query: self.query, completeHandler: completeHandler)
        })
    }
}
