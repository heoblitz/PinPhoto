//
//  SuggestHeaderView.swift
//  PinPhoto
//
//  Created by heo on 2020/12/21.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit
import Kingfisher

final class SuggestHeaderView: UICollectionReusableView {
    // MARK:- @IBOutlet Properties
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var headerNameLabel: UILabel!
    
    // MARK:- Properties
    static let reuseIdentifier: String = "SuggestHeaderView"
    
    // MARK:- Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func update(by unsplash: Unsplash) {
        headerImage.kf.setImage(with: URL(string: unsplash.thumnail.small))
        headerNameLabel.text = "Photo by " + unsplash.name
    }
}
