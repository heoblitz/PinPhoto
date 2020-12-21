//
//  UnsplashViewModel.swift
//  PinPhoto
//
//  Created by heo on 2020/12/21.
//  Copyright © 2020 won heo. All rights reserved.
//

import Foundation

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
}
