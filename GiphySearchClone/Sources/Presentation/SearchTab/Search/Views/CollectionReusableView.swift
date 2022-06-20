//
//  CollectionReusableView.swift
//  GiphySearchClone
//
//  Created by yupzip on 2022/06/19.
//

import UIKit

class CollectionReusableView: UICollectionReusableView {
    
    static let identifier = "CollectionReusableView"
    @IBOutlet weak var gifImageView: UIImageView!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var favoriteButtonImageView: UIImageView!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!


    var favoriteAction : (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        let favoriteButtonImageViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(favoriteButtonImageViewTapped(_:)))
        favoriteButtonImageView.addGestureRecognizer(favoriteButtonImageViewTapGesture)
        
        
        gifImageView.layer.cornerRadius = 5
        
    }
    
    @objc func favoriteButtonImageViewTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        
        favoriteAction?()
        
    }
    
}
