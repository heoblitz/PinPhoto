//
//  HomeSectionReusableView.swift
//  PinPhoto
//
//  Created by won heo on 2020/09/09.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit

class HomeSectionReusableView: UICollectionReusableView {
    // MARK:- Properties
    static let reuseIdentifier: String = "HomeSectionReusableView"
    
    // MARK:- Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .red
    }
    
}
