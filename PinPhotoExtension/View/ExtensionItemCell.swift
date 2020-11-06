//
//  ExtensionItemCell.swift
//  PinPhotoExtension
//
//  Created by won heo on 2020/07/30.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit

final class ExtensionItemCell: UICollectionViewCell {
    // MARK:- @IBOutlet Properties
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var contentTextLabel: UILabel!
    
    // MARK:- Propertises
    var itemType: String = "" {
        didSet {
            switch itemType {
            case "image":
                contentTextLabel.isHidden = true
            case "text":
                contentImageView.isHidden = true
            default:
                break
            }
        }
    }

    // MARK:- Method
    override func awakeFromNib() {
        super.awakeFromNib()
        reset()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }
    
    private func reset() {
        contentImageView.isHidden = false
        contentImageView.image = nil
        contentTextLabel.isHidden = false
        contentTextLabel.text = nil
    }
    
    func update(item: Item) {
        contentImageView.image = item.contentImage?.image
        contentTextLabel.text = item.contentText
        
        if item.contentType == 0 {
            itemType = "image"
        } else {
            itemType = "text"
        }
    }

}
