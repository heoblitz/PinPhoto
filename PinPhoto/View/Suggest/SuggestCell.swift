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
        layer.cornerRadius = 12
        layer.masksToBounds = true
    }
    
    func update(by unsplash: Unsplash) {
        suggestNameLabel.text = unsplash.name
        suggestImageView.kf.setImage(with: URL(string: unsplash.thumnail.small))
    }
}
