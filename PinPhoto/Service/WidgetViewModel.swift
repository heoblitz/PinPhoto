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
    private let displayItemIndexKey: String = "displayItemIndex"
    private let showAllItemsKey: String = "showAllItemsKey"
    private let changeItemTimeKey: String = "changeItemTime"
    
    var height: Float {
        get {
            return defaults?.value(forKey: widgetHeightKey) as? Float ?? 300
        }
        set {
            defaults?.set(newValue, forKey: widgetHeightKey)
            defaults?.synchronize()
        }
    }
    
    var isImageFill: Bool {
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
    
    var displayItemIndex: Int? {
        get {
            return defaults?.value(forKey: displayItemIndexKey) as? Int
        }
        set {
            defaults?.set(newValue, forKey: displayItemIndexKey)
            defaults?.synchronize()

            if #available(iOS 14, *) {
                RefreshWidget()
            }
        }
    }
    
    var isShowAllItems: Bool {
        get {
            return defaults?.value(forKey: showAllItemsKey) as? Bool ?? false
        }
        set {
            defaults?.set(newValue, forKey: showAllItemsKey)
            defaults?.synchronize()
            
            if #available(iOS 14, *) {
                RefreshWidget()
            }
        }
    }
    
    var changeItemTime: Date? {
        get {
            if let date = defaults?.object(forKey: changeItemTimeKey) as? Date {
                return date
            } else {
                return nil
            }
        }
        set {
            defaults?.set(newValue, forKey: changeItemTimeKey)
            defaults?.synchronize()

            if #available(iOS 14, *) {
                RefreshWidget()
            }
        }
    }
    
    var changeTimeSecond: TimeInterval {
        get {
            guard let date = defaults?.object(forKey: changeItemTimeKey) as? Date else {
                return 60
            }
            
            let calendar = Calendar.current
            let components = calendar.dateComponents([.hour, .minute], from: date)
            
            return TimeInterval(((components.hour ?? 0) * 3600 + ((components.minute ?? 0) * 60)))
        }
    }
    
    @available(iOS 14, *)
    func RefreshWidget() {
        WidgetCenter.shared.reloadAllTimelines()
    }
}
