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
    @IBOutlet weak var displayLabel: UILabel!
    
    // MARK:- Propertises
    static let cellIdentifier: String = "itemCustomCell"
    private var disabledHighlightedAnimation: Bool = false
    
    var itemType: ItemType = .image {
        didSet {
            switch itemType {
            case .image:
                itemTextLabel.isHidden = true
            case .text:
                itemImageView.isHidden = true
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
    
    var isCellDisplayItem: Bool = false {
        didSet {
            if isCellDisplayItem {
                displayLabel.isHidden = false
            } else {
                displayLabel.isHidden = true
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        reset()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
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

    private func animate(isHighlighted: Bool) {
        if disabledHighlightedAnimation || HomeDetailViewController.isEditMode {
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
    
    private func reset() {
        itemImageView.isHidden = false
        itemTextLabel.isHidden = false
        isCellDisplayItem = false
    }
    
    func update(_ item: Item) {
        itemImageView.image = item.contentImage?.image
        itemTextLabel.text = item.contentText
        
        switch item.contentType {
        case ItemType.image.value:
            itemType = .image
        case ItemType.text.value:
            itemType = .text
        default:
            break
        }
    }
    
    func freezeAnimations() {
        disabledHighlightedAnimation = true
        layer.removeAllAnimations()
    }

    func unfreezeAnimations() {
        disabledHighlightedAnimation = false
    }
    
}
