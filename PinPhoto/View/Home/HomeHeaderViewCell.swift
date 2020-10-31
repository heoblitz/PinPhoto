//
//  HomeHeaderViewCell.swift
//  PinPhoto
//
//  Created by won heo on 2020/09/09.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit

class HomeHeaderViewCell: UICollectionViewCell {
    // MARK:- @IBOutlet Properties
    @IBOutlet private weak var headerImageView: UIImageView!
    @IBOutlet private weak var headerTextLabel: UILabel!
    @IBOutlet private weak var groupNameLabel: UILabel!
    @IBOutlet private weak var noticeTextLabel: UILabel!

    // MARK:- Properties
    static let cellIdentifier: String = "HomeHeaderViewCell"
    var disabledHighlightedAnimation: Bool = false

    // MARK:- Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 10
        groupNameLabel.text = "위젯에 표시될 항목".localized
        noticeTextLabel.text = "Please Add Items".localized
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
        headerImageView.image = nil
        headerTextLabel.text = nil
        noticeTextLabel.isHidden = false
        headerImageView.isHidden = false
        headerTextLabel.isHidden = false
    }
    
    func update(at item: Item?) {
        guard let item = item else { return }
        
        switch item.contentType {
        case ItemType.image.value:
            headerImageView.image = item.contentImage?.image?.greyScale
            headerTextLabel.isHidden = true
        case ItemType.text.value:
            headerTextLabel.text = item.contentText
            headerImageView.isHidden = true
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
