//
//  ExtensionItemCell.swift
//  PinPhotoExtension
//
//  Created by won heo on 2020/07/30.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit

class ExtensionItemCell: UICollectionViewCell {
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var contentTextLabel: UILabel!
    
    var itemtype: String = "image" {
        didSet {
            switch self.itemtype {
            case "image":
                contentTextLabel.isHidden = true
                contentImageView.isHidden = false
            case "text":
                contentTextLabel.isHidden = false
                contentImageView.isHidden = true
            default:
                break
            }
        }
    }
}
