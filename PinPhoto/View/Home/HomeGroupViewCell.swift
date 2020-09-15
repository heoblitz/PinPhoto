//
//  HomeGroupViewCell.swift
//  PinPhoto
//
//  Created by won heo on 2020/09/09.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit

class HomeGroupViewCell: UICollectionViewCell {
    @IBOutlet private weak var groupImageView: UIImageView!
    @IBOutlet private weak var groupNameLabel: UILabel!
    @IBOutlet private weak var noticeTextLabel: UILabel!
    
    var disabledHighlightedAnimation: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 10
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
        if disabledHighlightedAnimation {
            return
        }
        
        UIView.animate(withDuration: 0.3) {
            if isHighlighted {
                self.contentView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }
            else {
                self.contentView.transform = .identity
            }
        }
    }
    
    func update(at item: Item?, title: String) {
        if let item = item {
            groupImageView.image = item.contentImage?.image
            noticeTextLabel.isHidden = true
        }
        groupNameLabel.text = title
    }
    
    private func reset() {
        noticeTextLabel.isHidden = false
        groupImageView.image = nil
    }
    
    func freezeAnimations() {
        disabledHighlightedAnimation = true
        layer.removeAllAnimations()
    }

    func unfreezeAnimations() {
        disabledHighlightedAnimation = false
    }
}
