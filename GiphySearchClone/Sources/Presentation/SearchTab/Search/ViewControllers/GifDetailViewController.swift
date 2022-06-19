//
//  GifDetailViewController.swift
//  GiphySearchClone
//
//  Created by yupzip on 2022/06/19.
//

import UIKit

class GifDetailViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var backButtonImageView: UIImageView!
    
    @IBOutlet weak var gifListCollectionView: UICollectionView!
    
    static let identifier = "GifDetailViewController"
    
    var detailGif: Gif?
    
    var gifList: [Gif] = []
    
    // MARK: View Control
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        
    }
    
    func setUpView() {
        let backButtonImageViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(backButtonImageViewTapped(_:)))
        backButtonImageView.addGestureRecognizer(backButtonImageViewTapGesture)
        
        gifListCollectionView.delegate = self
        gifListCollectionView.dataSource = self
        gifListCollectionView.register(UINib(nibName: CVGifCell.identifier, bundle: nil), forCellWithReuseIdentifier: CVGifCell.identifier)
        gifListCollectionView.register(UINib(nibName: CollectionReusableView.identifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionReusableView.identifier)
    }
    
    // MARK: User Actions
    @objc func backButtonImageViewTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: Helper Methods
    
    
}

extension GifDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gifList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CVGifCell.identifier, for: indexPath) as! CVGifCell
        
        cell.gifImageView.setImageUrl(gifList[indexPath.row].images.previewGIF.url)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionReusableView.identifier, for: indexPath) as! CollectionReusableView
        
            guard let detailGif = detailGif else { return UICollectionReusableView() }
            headerView.gifImageView.setImageUrl(detailGif.images.original.url)
            
            return headerView
    
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let width: CGFloat = collectionView.frame.width
        let height: CGFloat = 100
        
        guard let detailGif = detailGif else { return  CGSize(width: width, height: height) }
        
        let imageWidth: Double = Double(detailGif.images.original.width) ?? 0.0
        let imageHeight: Double = Double(detailGif.images.original.height) ?? 0.0
        let ratio = CGFloat(imageWidth / imageHeight)
        let newHeight = (width - 60) / ratio
        return CGSize(width: width, height: newHeight + 70)
    }
}
