//
//  ClassNameToString.swift
//  PinPhoto
//
//  Created by won heo on 2020/08/17.
//  Copyright © 2020 won heo. All rights reserved.
//

import Foundation

public extension NSObject {
    static func storyboardName() -> String {
        return String(describing: self).replacingOccurrences(of: "ViewController", with: "")
    }
    
    static func observerName() -> String {
        return String(describing: self)
    }
}
