//
//  SuggestCell.swift
//  PinPhoto
//
//  Created by heo on 2020/12/21.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit
import Kingfisher

final class SuggestCell: UICollectionViewCell {
    // MARK:- @IBOutlet Properties
    @IBOutlet weak var suggestImageView: UIImageView!
    @IBOutlet weak var suggestNameLabel: UILabel!
    
    // MARK:- Propertises
    static let cellIdentifier: String = "SuggestCell"
    
    // MARK:- Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
    }
    
    func update(by unsplash: Unsplash) {
        suggestNameLabel.text = unsplash.name
        suggestImageView.kf.setImage(with: URL(string: unsplash.thumnail.small))
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
        UIView.animate(withDuration: 0.3) {
            if isHighlighted {
                self.contentView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }
            else {
                self.contentView.transform = .identity
            }
        }
    }
}
