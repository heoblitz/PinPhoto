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
    let unsplash: Observable<[Unsplash]> = Observable([])
    
    init() {
        requestItems()
    }
    
    func requestItems() {
        Api.shared.request { unsplashes in
            OperationQueue.main.addOperation {
                self.unsplash.value = unsplashes
            }
        }
    }
    
    func downloadInitialImages(completeHandler: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        let globalQueue = DispatchQueue.global()
        let downloader = ImageDownloader.default
        
        globalQueue.async(group: dispatchGroup, execute: {
            self.unsplash.value.forEach { unsplash in
                let urlString = unsplash.thumnail.small
                guard let url = URL(string: urlString) else { return }
                downloader.downloadImage(with: url, completionHandler: { result in
                    switch result {
                    case .success(let value):
                        print(value, urlString)
                        ImageCache.default.store(value.image, forKey: urlString)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                })
            }
        })
        
        dispatchGroup.notify(queue: globalQueue, execute: {
            print("downloaded")
            completeHandler()
        })
    }
}
