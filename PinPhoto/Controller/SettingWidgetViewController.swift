//
//  SettingWidgetViewController.swift
//  PinPhoto
//
//  Created by won heo on 2020/08/19.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit

class SettingWidgetViewController: UIViewController {
    @IBOutlet private weak var widgetImageView: UIImageView!
    @IBOutlet private weak var widgetHeaderView: UIView!
    @IBOutlet private weak var heightSilder: UISlider!
    
    private var selectionGenerator: UISelectionFeedbackGenerator!
    private var currentValue: Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.widgetImageView.translatesAutoresizingMaskIntoConstraints = false
        // Do any additional setup after loading the view.
        var height: Float = 300
        if let getHeight = getWidgetHeight(), getHeight != 0.0 { height = getHeight }
        let value = (height - 200) / 50
        
        self.heightSilder.value = value
        self.saveWidgetHeight(at: height)
        self.currentValue = value
        self.selectionGenerator = UISelectionFeedbackGenerator()
        self.selectionGenerator?.prepare()
        
        self.widgetHeaderView.clipsToBounds = true
        self.widgetHeaderView.layer.cornerRadius = 10
        self.widgetHeaderView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        self.widgetImageView.clipsToBounds = true
        self.widgetImageView.layer.cornerRadius = 10
        self.widgetImageView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let height = 200 + (currentValue * 50)
        self.setWidgetImageHeight(height)
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
        for constraint in widgetImageView.constraints {
            if constraint.identifier == "widgetHeight" {
               constraint.constant = CGFloat(height)
            }
        }
        widgetImageView.layoutIfNeeded()
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        let mul = round(sender.value)
        let height = 200 + (mul * 50)
        sender.value = mul

        if mul != currentValue {
            currentValue = mul
            saveWidgetHeight(at: height)
            setWidgetImageHeight(height)
            selectionGenerator?.selectionChanged()
        }
    }
}
