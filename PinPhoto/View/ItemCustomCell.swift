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
    
    // MARK:- Propertises
    static let cellIdentifier: String = "itemCustomCell"
    var disabledHighlightedAnimation: Bool = false
    
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animate(isHighlighted: true)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animate(isHighlighted: false)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animate(isHighlighted: false)
    }
    
    private func freezeAnimations() {
        disabledHighlightedAnimation = true
        layer.removeAllAnimations()
    }

    private func unfreezeAnimations() {
        disabledHighlightedAnimation = false
    }
    
    private func animate(isHighlighted: Bool) {
        if disabledHighlightedAnimation || HomeViewController.isEditMode {
            return
        }
        
        UIView.animate(withDuration: 0.3) {
            if isHighlighted {
                self.contentView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }
            else {
                self.contentView.transform = .identity
            }
        }
    }
}
