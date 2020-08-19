//
//  SettingWidgetViewController.swift
//  PinPhoto
//
//  Created by won heo on 2020/08/19.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit

class SettingWidgetViewController: UIViewController {
    @IBOutlet private weak var widgetImage: UIImageView!
    @IBOutlet private weak var widgetHeaderView: UIView!
    @IBOutlet private weak var widgetFooterView: UIView!
    @IBOutlet private weak var heightSilder: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.widgetImage.translatesAutoresizingMaskIntoConstraints = false
        // Do any additional setup after loading the view.
        if let height = getWidgetHeight() {
            let value = (height - 200) / 50
            self.heightSilder.value = value
            self.setWidgetImageHeight(height)
        } else {
            self.saveWidgetHeight(at: 300)
            self.setWidgetImageHeight(300)
        }
        
        widgetHeaderView.clipsToBounds = true
        widgetHeaderView.layer.cornerRadius = 10
        widgetHeaderView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        widgetFooterView.clipsToBounds = true
        widgetFooterView.layer.cornerRadius = 10
        widgetFooterView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    
    // MARK:- Methods
    static func storyboardInstance() -> SettingWidgetViewController? {
        let storyboard = UIStoryboard(name: SettingWidgetViewController.storyboardName(), bundle: nil)
        return storyboard.instantiateInitialViewController()
    }
    
    func saveWidgetHeight(at height: Float) {
        let defaults = UserDefaults(suiteName: "group.com.wonheo.PinPhoto")
        defaults?.set(height, forKey: "widgetHeight")
    }
    
    func getWidgetHeight() -> Float? {
        let defaults = UserDefaults(suiteName: "group.com.wonheo.PinPhoto")
        return defaults?.float(forKey: "widgetHeight")
    }
    
    func setWidgetImageHeight(_ height: Float) {
        for constraint in widgetImage.constraints {
            if constraint.identifier == "widgetHeight" {
               constraint.constant = CGFloat(height)
            }
        }
        widgetImage.layoutIfNeeded()
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        let mul = round(sender.value)
        let height = 200 + (mul * 50)
        
        sender.value = mul
        saveWidgetHeight(at: height)
        setWidgetImageHeight(height)
    }
}
