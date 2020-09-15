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
    
    var greyScale: UIImage? {
        guard let filter = CIFilter(name: "CIExposureAdjust"), let image = CIImage(image: self) else { return nil }
        filter.setValue(image, forKey: kCIInputImageKey)
        filter.setValue(-0.5, forKey: kCIInputEVKey)
    
        guard let ciImage = filter.outputImage else { return nil }
        
        return UIImage(ciImage: ciImage)
    }
}

public extension Data {
    var image: UIImage? {
        return UIImage(data: self)
    }
}
