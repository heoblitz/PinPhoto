//
//  PinterestLayout.swift
//  PinPhoto
//
//  Created by heo on 2020/12/21.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit


import UIKit

protocol PinterestLayoutDelegate: AnyObject {
    func collectionView(
        _ collectionView: UICollectionView,
        heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat
    
    func itemCount() -> Int
}

class PinterestLayout: UICollectionViewFlowLayout {
    // 1
    // item height 가져오기 위해서 사용, delegate 패턴
    weak var delegate: PinterestLayoutDelegate?
    
    // 2
    // 컬럼이 몇개 인지, 핀터레스트 스타일은 2개다.
    private let numberOfColumns = 2
    private let cellPadding: CGFloat = 2
    
    // 3
    private var cache: [UICollectionViewLayoutAttributes] = []
    
    // 4
    private var contentHeight: CGFloat = 0
    
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    // 5
    private var xOffset: [CGFloat] = []
    private var yOffset: [CGFloat] = .init(repeating: 22, count: 2)

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        // 1 cache.isEmpty,
        guard let collectionView = collectionView else {
            return
        }
        
        guard cache.count != delegate?.itemCount() else {
            return
        }
        
        // 2
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        for column in 0..<numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        
        var column = 0
        
        // 3
        for item in cache.count..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            // 4
            // item 크기와 x, y 좌표를 포함한 CGRect 값을 생성한다.
            let photoHeight = delegate?.collectionView(
                collectionView,
                heightForPhotoAtIndexPath: indexPath) ?? 180
            let height = cellPadding * 2 + photoHeight
            let frame = CGRect(x: xOffset[column],
                               y: yOffset[column],
                               width: columnWidth,
                               height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            // 5
            // 위에서 계산 한 값을 토대로 UICollectionViewLayoutAttributes 를 만든다.
            // 이 때 indexPath 가 필요하다.
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            // 6
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
            
            column = yOffset[0] > yOffset[1] ? 1 : 0
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect)
    -> [UICollectionViewLayoutAttributes]? {
        guard let layoutAttributes = super.layoutAttributesForElements(in: rect), let offset = collectionView?.contentOffset else { return nil }
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        for layoutAttributesSet in layoutAttributes {
            if layoutAttributesSet.representedElementCategory == .supplementaryView {
                // Update Sections to Add
                visibleLayoutAttributes.append(layoutAttributesSet)
                
                //
                let diffValue = abs(offset.y)
                var frame = layoutAttributesSet.frame
                frame.size.height = max(0, headerReferenceSize.height + diffValue)
                frame.origin.y = frame.minY - diffValue
                layoutAttributesSet.frame = frame
                break
            }
        }
        
        // Loop through the cache and look for items in the rect
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath)
    -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}
