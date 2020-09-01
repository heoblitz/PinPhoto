//
//  WidgetViewModel.swift
//  PinPhoto
//
//  Created by won heo on 2020/09/01.
//  Copyright © 2020 won heo. All rights reserved.
//

import Foundation

public class WidgetViewModel {
    private let defaults: UserDefaults? = UserDefaults(suiteName: "group.com.wonheo.PinPhoto")
    private let widgetHeightKey: String = "widgetHeight"
    private let widgetImageFillKey: String = "widgetImageFill"
    
    var height: Float {
        get {
            return defaults?.value(forKey: widgetHeightKey) as? Float ?? 300
        }
        set {
            defaults?.set(newValue, forKey: widgetHeightKey)
        }
    }
    
    var shouldImageFill: Bool {
        get {
            return defaults?.value(forKey: widgetImageFillKey) as? Bool ?? false
        }
        set {
            defaults?.set(newValue, forKey: widgetImageFillKey)
        }
    }
}
