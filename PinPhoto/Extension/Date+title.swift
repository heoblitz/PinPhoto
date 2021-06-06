//
//  DateExtension.swift
//  PinPhoto
//
//  Created by won heo on 2020/10/29.
//  Copyright © 2020 won heo. All rights reserved.
//

import Foundation

extension Date {
    var title: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .full
        dateFormatter.locale = Locale.current
        dateFormatter.doesRelativeDateFormatting = true
        
        return dateFormatter.string(from: self)
    }
}
