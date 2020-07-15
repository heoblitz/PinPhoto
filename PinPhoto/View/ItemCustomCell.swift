//
//  ItemCustomCell.swift
//  PinPhoto
//
//  Created by won heo on 2020/07/13.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit

class ItemCustomCell: UICollectionViewCell {
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemText: UITextView!
    @IBOutlet weak var checkImage: UIImageView!
    
    var itemtype: String = "image" {
        didSet {
            switch self.itemtype {
            case "image":
                itemText.isHidden = true
                itemImage.isHidden = false
            case "text":
                itemText.isHidden = false
                itemImage.isHidden = true
            default:
                break
            }
        }
    }
    
    var isSelectedForRemove: Bool = false {
        didSet {
            if isSelectedForRemove {
                checkImage.isHidden = false
                itemImage.alpha = 0.5
                itemText.alpha = 0.5
            } else {
                checkImage.isHidden = true
                itemText.alpha = 1
                //itemImage.layer.borderWidth = 0
                itemImage.alpha = 1
            }
        }
    }
}
