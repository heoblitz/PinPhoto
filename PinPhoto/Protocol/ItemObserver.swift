//
//  ItemObserver.swift
//  PinPhoto
//
//  Created by won heo on 2020/07/31.
//  Copyright © 2020 won heo. All rights reserved.
//

import Foundation

public protocol ItemObserver {
    func updateItem()
    func errorItem(_ error: Error)
}

public protocol GroupObserver: class {
    var groupIdentifier: String { get }
    func updateGroup()
}
