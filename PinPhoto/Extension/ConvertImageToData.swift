//
//  ConvertImageToData.swift
//  PinPhoto
//
//  Created by won heo on 2020/08/31.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit

public extension UIImage {
    var data: Data? {
        return self.pngData()
    }
}

public extension Data {
    var image: UIImage? {
        return UIImage(data: self)
    }
}
