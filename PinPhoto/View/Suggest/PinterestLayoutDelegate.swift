//
//  PinterestLayoutDelegate.swift
//  PinPhoto
//
//  Created by won heo on 2020/12/27.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit

protocol PinterestLayoutDelegate: AnyObject {
    func collectionView(
        _ collectionView: UICollectionView,
        heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat
    
    func itemCount() -> Int
}
