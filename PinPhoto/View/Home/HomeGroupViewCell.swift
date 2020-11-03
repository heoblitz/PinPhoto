//
//  HomeGroupViewCell.swift
//  PinPhoto
//
//  Created by won heo on 2020/09/09.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit

final class HomeGroupViewCell: UICollectionViewCell {
    // MARK:- @IBOutlet Properties
    @IBOutlet private weak var groupImageView: UIImageView!
    @IBOutlet private weak var groupTextLabel: UILabel!
    @IBOutlet private weak var groupNameLabel: UILabel!
    @IBOutlet private weak var noticeTextLabel: UILabel!
    
    // MARK:- Properties
    static let cellIdentifier: String = "HomeGroupViewCell"
    var disabledHighlightedAnimation: Bool = false
    
    // MARK:- Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 10
        noticeTextLabel.text = "Please Add Items".localized
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
    
    private func reset() {
        groupImageView.image = nil
        groupTextLabel.text = nil
        groupImageView.isHidden = false
        groupTextLabel.isHidden = false
        noticeTextLabel.isHidden = false
    }
    
    func update(at item: Item?, title: String) {
        groupNameLabel.text = title
        
        guard let item = item else { return }
        
        switch item.contentType {
        case ItemType.image.value:
            groupImageView.image = item.contentImage?.image?.greyScale
            groupTextLabel.isHidden = true
        case ItemType.text.value:
            groupTextLabel.text = item.contentText
            groupImageView.isHidden = true
        default:
            break
        }
        
        noticeTextLabel.isHidden = true
    }
    
    func freezeAnimations() {
        disabledHighlightedAnimation = true
        layer.removeAllAnimations()
    }

    func unfreezeAnimations() {
        disabledHighlightedAnimation = false
    }
}
