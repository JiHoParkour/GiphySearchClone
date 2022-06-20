//
//  GifDetailViewController.swift
//  GiphySearchClone
//
//  Created by yupzip on 2022/06/19.
//

import UIKit
import CoreData

class GifDetailViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var backButtonImageView: UIImageView!
    
    @IBOutlet weak var gifListCollectionView: UICollectionView!
    
    static let identifier = "GifDetailViewController"
    
    var detailGif: Gif?
    
    var gifList: [Gif] = []
    
    var container: NSPersistentContainer!
    
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
    
    
    private func saveGifFavorite(gifId: String, isFavorite: String) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.container = appDelegate.persistentContainer
        
        let context = appDelegate.persistentContainer.viewContext
        
        
        let fetchFavorite: NSFetchRequest<GifFavorite> = GifFavorite.fetchRequest()
        fetchFavorite.predicate = NSPredicate(format: "id = %@", gifId as String)
        
        let results = try? context.fetch(fetchFavorite)
        
        var gifFavorite: GifFavorite!
        
        if results?.count == 0 {
            gifFavorite = GifFavorite(context: context)
        } else {
            gifFavorite = results?.filter{ $0.id == gifId }[0]
        }
        
        gifFavorite.id = gifId
        gifFavorite.isFavorite = isFavorite
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        
        
    }
    
    
    private func updateGifFavorite(gifId: String) -> Bool {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            
            let gifFavorites = try context.fetch(GifFavorite.fetchRequest()) as! [GifFavorite]
            
            var isContain: Bool = false
            
            for gifFavorite in gifFavorites {
                
                if (gifFavorite.id! == gifId) {
                    isContain = true
                }
            }
            
            if (isContain) {
                let gifFavorite = gifFavorites.filter { $0.id! == gifId }.first!
                
                
                if (gifFavorite.isFavorite == "on") {
                    saveGifFavorite(gifId: gifId, isFavorite: "off")
                    return false
                    
                } else {
                    saveGifFavorite(gifId: gifId, isFavorite: "on")
                    return true
                }
                
            } else {
                saveGifFavorite(gifId: gifId, isFavorite: "on")
                return true
                
            }
            
            
        } catch {
            print(error.localizedDescription)
            return false
        }
        
    }
    
    
    private func fetchGifFavorite(gifId: String) -> Bool {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            
            let gifFavorites = try context.fetch(GifFavorite.fetchRequest()) as! [GifFavorite]
            
            for gifFavorite in gifFavorites {
                
                if (gifFavorite.id! == gifId) {
                    if (gifFavorite.isFavorite == "on") {
                        return true
                    } else {
                        return false
                    }
                }
                
            }
            return false
            
        } catch {
            print(error.localizedDescription)
            return false
        }
        
    }
    
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
            
            if let user = detailGif.user {
                headerView.userProfileImageView.setImageUrl(user.avatarURL)
                headerView.displayNameLabel.text = user.displayName
                headerView.userNameLabel.text = "@\(user.username)"
                headerView.sourceLabel.isHidden = true
            } else {
                headerView.userProfileImageView.image = UIImage(named: Constants.earth)
                headerView.displayNameLabel.text = detailGif.source
                headerView.userNameLabel.isHidden = true
            }
            
            headerView.favoriteButtonImageView.image = fetchGifFavorite(gifId: detailGif.id) ? UIImage(named: Constants.favoriteOn) : UIImage(named: Constants.favoriteOff)
            
            headerView.favoriteAction = {
                headerView.favoriteButtonImageView.image = self.updateGifFavorite(gifId: detailGif.id) ? UIImage(named: Constants.favoriteOn) : UIImage(named: Constants.favoriteOff)
            }
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
