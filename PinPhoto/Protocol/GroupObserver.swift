//
//  GroupObserver.swift
//  PinPhoto
//
//  Created by heo on 2020/11/05.
//  Copyright © 2020 won heo. All rights reserved.
//

import Foundation

public protocol GroupObserver: class {
    var groupIdentifier: String { get }
    func updateGroup()
}
