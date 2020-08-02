//
//  ItemCustomCell.swift
//  PinPhoto
//
//  Created by won heo on 2020/07/13.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit

class ItemCustomCell: UICollectionViewCell {
    // MARK:- @IBOutlet Properties
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemTextLabel: UILabel!
    @IBOutlet weak var checkImageView: UIImageView!
    
    var itemtype: String = "image" {
        didSet {
            switch self.itemtype {
            case "image":
                itemTextLabel.isHidden = true
                itemImageView.isHidden = false
            case "text":
                itemTextLabel.isHidden = false
                itemImageView.isHidden = true
            default:
                break
            }
        }
    }
    
    var isSelectedForRemove: Bool = false {
        didSet {
            if isSelectedForRemove {
                checkImageView.isHidden = false
                itemImageView.alpha = 0.5
                itemTextLabel.alpha = 0.5
            } else {
                checkImageView.isHidden = true
                itemTextLabel.alpha = 1
                itemImageView.alpha = 1
            }
        }
    }
}
