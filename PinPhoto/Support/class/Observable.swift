//
//  Observable.swift
//  PinPhoto
//
//  Created by heo on 2020/12/21.
//  Copyright © 2020 won heo. All rights reserved.
//

import Foundation

final class Observable<T> {
    typealias Observer = (T) -> ()
    
    var observer: Observer?
    
    var value: T {
        didSet {
            observer?(value)
        }
    }

    init(_ value: T) {
        self.value = value
    }
    
    func bind(observer: Observer?) {
        self.observer = observer
        observer?(value)
    }
}
