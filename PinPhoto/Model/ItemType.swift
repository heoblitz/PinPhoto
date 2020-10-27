//
//  ItemEnum.swift
//  PinPhoto
//
//  Created by won heo on 2020/09/12.
//  Copyright © 2020 won heo. All rights reserved.
//

import Foundation

public enum ItemType: CaseIterable {
    case image
    case text
    
    var value: Int64 {
        switch self {
        case .image:
            return 0
        case .text:
            return 1
        }
    }
    
    var title: String {
        switch self {
        case .image:
            return "Add Image".localized
        case .text:
            return "Add Text".localized
        }
    }
}
