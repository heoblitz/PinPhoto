//
//  WidgetViewModel.swift
//  PinPhoto
//
//  Created by won heo on 2020/09/01.
//  Copyright © 2020 won heo. All rights reserved.
//

import Foundation
import WidgetKit

public class WidgetViewModel {
    private let defaults: UserDefaults? = UserDefaults(suiteName: "group.com.wonheo.PinPhoto")
    private let widgetHeightKey: String = "widgetHeight"
    private let widgetImageFillKey: String = "widgetImageFill"
    private let currentIndexKey: String = "widgetIndex"
    private let isDisplayItemKey: String = "isDisplayItem"
    
    var height: Float {
        get {
            return defaults?.value(forKey: widgetHeightKey) as? Float ?? 300
        }
        set {
            defaults?.set(newValue, forKey: widgetHeightKey)
            defaults?.synchronize()
        }
    }
    
    var shouldImageFill: Bool {
        get {
            return defaults?.value(forKey: widgetImageFillKey) as? Bool ?? false
        }
        set {
            defaults?.set(newValue, forKey: widgetImageFillKey)
            defaults?.synchronize()
        }
    }
    
    var currentIndex: Int? {
        get {
            return defaults?.value(forKey: currentIndexKey) as? Int
        }
        set {
            defaults?.set(newValue, forKey: currentIndexKey)
            defaults?.synchronize()
        }
    }
    
    var isDisplayItem: Int? {
        get {
            return defaults?.value(forKey: isDisplayItemKey) as? Int
        }
        set {
            defaults?.set(newValue, forKey: isDisplayItemKey)
            
            if #available(iOS 14, *) {
                RefreshWidget()
            }
        }
    }
    
    @available(iOS 14, *)
    func RefreshWidget() {
        WidgetCenter.shared.reloadAllTimelines()
    }
}
