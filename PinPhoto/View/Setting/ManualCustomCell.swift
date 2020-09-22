//
//  ManualCustomCell.swift
//  PinPhoto
//
//  Created by won heo on 2020/08/02.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit

class ManualCustomCell: UICollectionViewCell {
    // MARK:- @IBOutlet Properties
    @IBOutlet weak var manualImageView: UIImageView!
    @IBOutlet weak var manualTextLabel: UILabel!
    
    // MARK:- Properties
    static let cellIdentifier: String = "manualCustomCell"
}
