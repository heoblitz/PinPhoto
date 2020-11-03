//
//  SettingWidgetSwitchCell.swift
//  PinPhoto
//
//  Created by won heo on 2020/08/22.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit

final class SettingWidgetSwitchCell: UITableViewCell {
    // MARK:- @IBOutlet Properties
    @IBOutlet weak var imageSwitch: UISwitch!
    @IBOutlet weak var imageInfoLabel: UILabel!
    
    // MARK:- Propertises
    static let cellIdentifier: String = "settingWidgetSwitchCell"
}
