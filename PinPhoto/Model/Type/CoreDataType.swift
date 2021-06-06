//
//  CoreDataType.swift
//  PinPhoto
//
//  Created by won heo on 2020/09/12.
//  Copyright © 2020 won heo. All rights reserved.
//

import Foundation

public enum CoreDataType {
    case widget
    case group
    
    var name: String {
        switch self {
        case .widget:
            return "Item"
        case .group:
            return "GroupItem"
        }
    }
}
