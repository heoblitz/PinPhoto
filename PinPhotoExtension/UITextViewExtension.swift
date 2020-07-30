//
//  UITextViewExtension.swift
//  PinPhotoExtension
//
//  Created by won heo on 2020/07/30.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit

extension UITextView {
    func centerVertically() {
        print("center")
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffSet = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffSet)
        contentOffset.y = -positiveTopOffset
    }
}
