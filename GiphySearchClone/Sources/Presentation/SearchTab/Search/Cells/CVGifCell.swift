//
//  CVGifCell.swift
//  GiphySearchClone
//
//  Created by yupzip on 2022/06/19.
//

import UIKit

class CVGifCell: UICollectionViewCell {
   
    @IBOutlet weak var gifImageView: UIImageView!
    static let identifier = "CVGifCell"
    
    override func layoutSubviews() {
        super.layoutSubviews()

        gifImageView.layer.cornerRadius = 5
        contentView.layer.cornerRadius = 5

    }
}
