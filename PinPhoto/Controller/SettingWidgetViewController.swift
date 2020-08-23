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
    @IBOutlet private weak var widgetSettingTableView: UITableView!
    
    private let defaults: UserDefaults? = UserDefaults(suiteName: "group.com.wonheo.PinPhoto")
    private var selectionGenerator: UISelectionFeedbackGenerator!
    private var currentValue: Float = 0
    private var isImageFill: Bool = false {
        didSet {
            if isImageFill {
                widgetImageView.contentMode = .scaleToFill
            } else {
                widgetImageView.contentMode = .scaleAspectFit
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        self.widgetSettingTableView.dataSource = self
        var height: Float = 300
        if let getHeight = getWidgetHeight(), getHeight != 0.0 { height = getHeight }
        let value = (height - 200) / 50
        
        self.isImageFill = getWidgetImageFill() ?? false
        
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
        self.widgetImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let height = 200 + (currentValue * 50)
        self.setWidgetImageHeight(height)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK:- Methods
    static func storyboardInstance() -> SettingWidgetViewController? {
        let storyboard = UIStoryboard(name: SettingWidgetViewController.storyboardName(), bundle: nil)
        return storyboard.instantiateInitialViewController()
    }
    
    private func saveWidgetHeight(at height: Float) {
        defaults?.set(height, forKey: "widgetHeight")
    }
    
    private func saveWidgetImageFill(by setting: Bool) {
        defaults?.set(setting, forKey: "widgetImageFill")
    }
    
    private func getWidgetHeight() -> Float? {
        return defaults?.float(forKey: "widgetHeight")
    }
    
    private func getWidgetImageFill() -> Bool? {
        return defaults?.bool(forKey: "widgetImageFill")
    }
    
    private func setWidgetImageHeight(_ height: Float) {
        for constraint in widgetImageView.constraints {
            if constraint.identifier == "widgetHeight" {
               constraint.constant = CGFloat(height - 10)
            }
        }
        widgetImageView.layoutIfNeeded()
    }
    
    @objc private func sliderChanged(_ sender: UISlider) {
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
    
    @objc private func swtichTapped(_ sender: UISwitch) {
        saveWidgetImageFill(by: sender.isOn)
        isImageFill = sender.isOn
    }
}

extension SettingWidgetViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingWidgetSwitchCell.cellIdentifier, for: indexPath) as? SettingWidgetSwitchCell else {
                return UITableViewCell()
            }
            cell.imageSwitch.addTarget(self, action: #selector(swtichTapped), for: .valueChanged)
            cell.imageSwitch.isOn = isImageFill
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingWidgetSliderCell.cellIdentifier, for: indexPath) as? SettingWidgetSliderCell else {
                return UITableViewCell()
            }
            cell.heightSilder.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
            cell.heightSilder.value = currentValue
            return cell
        default:
            return UITableViewCell()
        }
    }
}
