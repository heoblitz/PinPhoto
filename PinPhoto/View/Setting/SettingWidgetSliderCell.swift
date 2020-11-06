//
//  SettingWidgetSliderCell.swift
//  PinPhoto
//
//  Created by won heo on 2020/08/22.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit

final class SettingWidgetSliderCell: UITableViewCell {
    // MARK:- @IBOutlet Properties
    @IBOutlet weak var heightSilder: UISlider!
    @IBOutlet weak var heightBigLabel: UILabel!
    @IBOutlet weak var heightSmallLabel: UILabel!
    
    // MARK:- Propertises
    static let cellIdentifier: String = "settingWidgetSliderCell"
}
