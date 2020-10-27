//
//  LocalizedExtension.swift
//  PinPhoto
//
//  Created by won heo on 2020/10/26.
//  Copyright © 2020 won heo. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: "Localizable", value: self, comment: "")
    }
}
