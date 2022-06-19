//
//  DynamicHeightFlowLayout.swift
//  GiphySearchClone
//
//  Created by yupzip on 2022/06/19.
//

import UIKit

protocol DynamicHeightFlowLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, heightForCellAtIndexPath indexPath: IndexPath) -> CGFloat
}

class DynamicHeightFlowLayout: UICollectionViewFlowLayout {
    
    weak var delegate: DynamicHeightFlowLayoutDelegate?
    private var numberOfColumns = 2
    private var cellPadding: CGFloat = 2
    private var contentHeight: CGFloat = 0
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    private var cache: [UICollectionViewLayoutAttributes] = []
    
    override func prepare() {
        guard let collectionView = collectionView else { return }
    
        let cellWidth: CGFloat = contentWidth / CGFloat(numberOfColumns)
        
        var xOffSet = [CGFloat]()
        for column in 0 ..< numberOfColumns {
            xOffSet.append(CGFloat(column) * cellWidth)
        }
        var yOffSet: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
        var column: Int = 0

        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            
            let indexPath = IndexPath(item: item, section: 0)
            
            let cellHeight = delegate?.collectionView(collectionView, heightForCellAtIndexPath: indexPath) ?? 100
            let frameHeight = cellPadding * 2 + cellHeight
            
            let frame = CGRect(x: xOffSet[column],
                               y: yOffSet[column],
                               width: cellWidth,
                               height: frameHeight)
            
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            attributes.frame = insetFrame
            cache.append(attributes)
            contentHeight = max(contentHeight, frame.maxY)
            
            yOffSet[column] = yOffSet[column] + frameHeight
            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect)
    -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
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
