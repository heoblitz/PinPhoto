//
//  WidgetViewModel.swift
//  PinPhoto
//
//  Created by won heo on 2020/09/01.
//  Copyright © 2020 won heo. All rights reserved.
//

import Foundation
import WidgetKit

enum WidgetRepositoryKey: String {
    case widgetHeight
    case widgetImageFill
    case currentIndex
    case displayItemIndex
    case showAllItems
    case changeItemTime
}

public class WidgetRepository {
    private let defaults: UserDefaults? = UserDefaults(suiteName: "group.com.wonheo.PinPhoto")
    
    var height: Float {
        get {
            return defaults?.value(forKey: WidgetRepositoryKey.widgetHeight.rawValue) as? Float ?? 300
        }
        set {
            defaults?.set(newValue, forKey: WidgetRepositoryKey.widgetHeight.rawValue)
            defaults?.synchronize()
        }
    }
    
    var isImageFill: Bool {
        get {
            return defaults?.value(forKey: WidgetRepositoryKey.widgetImageFill.rawValue) as? Bool ?? false
        }
        set {
            defaults?.set(newValue, forKey:  WidgetRepositoryKey.widgetImageFill.rawValue)
            defaults?.synchronize()
        }
    }
    
    var currentIndex: Int? {
        get {
            return defaults?.value(forKey: WidgetRepositoryKey.currentIndex.rawValue) as? Int
        }
        set {
            defaults?.set(newValue, forKey: WidgetRepositoryKey.currentIndex.rawValue)
            defaults?.synchronize()
        }
    }
    
    var displayItemIndex: Int? {
        get {
            return defaults?.value(forKey: WidgetRepositoryKey.displayItemIndex.rawValue) as? Int
        }
        set {
            defaults?.set(newValue, forKey: WidgetRepositoryKey.displayItemIndex.rawValue)
            defaults?.synchronize()

            if #available(iOS 14, *) {
                RefreshWidget()
            }
        }
    }
    
    var isShowAllItems: Bool {
        get {
            return defaults?.value(forKey: WidgetRepositoryKey.showAllItems.rawValue) as? Bool ?? false
        }
        set {
            defaults?.set(newValue, forKey: WidgetRepositoryKey.showAllItems.rawValue)
            defaults?.synchronize()
            
            if #available(iOS 14, *) {
                RefreshWidget()
            }
        }
    }
    
    var changeItemTime: Date? {
        get {
            if let date = defaults?.object(forKey: WidgetRepositoryKey.changeItemTime.rawValue) as? Date {
                return date
            } else {
                return nil
            }
        }
        set {
            defaults?.set(newValue, forKey: WidgetRepositoryKey.changeItemTime.rawValue)
            defaults?.synchronize()

            if #available(iOS 14, *) {
                RefreshWidget()
            }
        }
    }
    
    var changeTimeSecond: TimeInterval {
        get {
            guard let date = defaults?.object(forKey: WidgetRepositoryKey.changeItemTime.rawValue) as? Date else {
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
