//
//  SearchViewController.swift
//  GiphySearchClone
//
//  Created by yupzip on 2022/06/18.
//

import UIKit
import Alamofire

class SearchGiphyViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var backButtonImageView: UIImageView!
    @IBOutlet weak var searchTitleLabel: UILabel!
    @IBOutlet weak var backButtionImageView: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButtionImageView: UIImageView!
    @IBOutlet weak var gifListCollectionView: UICollectionView!
    
    let searchGifsService = SearchGifsService()
    var gifPagination: Pagination?
    var gifList: [Gif] = []
    var searchKeyWord: String?
    
    // MARK: View Control
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        
        guard let searchKeyWord = searchKeyWord else { return }
        searchTitleLabel.text = searchKeyWord
        searchTextField.text = searchKeyWord
        searchGif(keyWord: searchKeyWord, offset: 0)
    }
    
    private func setUpView() {
        searchTextField.delegate = self
        searchTextField.returnKeyType = .search
        searchTextField.addLeftPadding()
        
        gifListCollectionView.delegate = self
        gifListCollectionView.dataSource = self
        gifListCollectionView.register(UINib(nibName: CVGifCell.identifier, bundle: nil), forCellWithReuseIdentifier: CVGifCell.identifier)
        gifListCollectionView.contentInset = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 3)
        
        let dynamicHeightFlowLayout = DynamicHeightFlowLayout()
        dynamicHeightFlowLayout.delegate = self // layout delegate 를 지정합니다.
        gifListCollectionView.collectionViewLayout = dynamicHeightFlowLayout

        let backButtonImageViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(backButtonImageViewTapped(_:)))
        backButtonImageView.addGestureRecognizer(backButtonImageViewTapGesture)
    }
    
    // MARK: User Actions
    @IBAction func searchButtonDidTap(_ sender: UIButton) {
        searchTextField.resignFirstResponder()
        if (searchTextField.text != "") {
            pushSearchViewController(keyWord: searchTextField.text!)
        }
    }
    
    
    @objc func backButtonImageViewTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: Helper Methods
    private func searchGif(keyWord: String, offset: Int) {
        searchGifsService.search(keyword: keyWord, offset: offset) { response in
            switch response {
            case .success(let gifData):
                if let gifData = gifData as? GifDataModel {
                    self.gifPagination = gifData.pagination
                    self.gifList.append(contentsOf: gifData.data)
                    
                    DispatchQueue.main.async {
                        self.gifListCollectionView.reloadData()
                        self.gifListCollectionView.layoutSubviews()
                    }
                    
                }
            case .networkFail:
                print("networkFail")
                
            default:
                break
            }
        }
    }
    
    private func pushSearchViewController(keyWord: String) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "SearchTab", bundle: nil)
        guard let searchGiphyViewController = storyBoard.instantiateInitialViewController() as? SearchGiphyViewController else {
            fatalError("Cannot instantiate initial view controller at \(Self.self) from storyboard")
        }
        searchGiphyViewController.searchKeyWord = keyWord
        self.navigationController?.pushViewController(searchGiphyViewController, animated: true)
    }
}

extension SearchGiphyViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        if (searchTextField.text != "") {
            pushSearchViewController(keyWord: searchTextField.text!)
        }
        return true
    }
}

extension SearchGiphyViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gifList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CVGifCell.identifier, for: indexPath) as! CVGifCell
        
        cell.gifImageView.image = nil
        
        let num = Int.random(in: 0...3)
        
        let colorName = PlaceholderColor(rawValue: num)
        
        switch colorName {
        case .Blue:
            cell.contentView.backgroundColor = UIColor(named: "Blue" )
        case .Purple:
            cell.contentView.backgroundColor = UIColor(named: "Purple" )
        case .Violet:
            cell.contentView.backgroundColor = UIColor(named: "Violet" )
        case .Pink:
            cell.contentView.backgroundColor = UIColor(named: "Pink" )
        default:
            break
        }

        cell.gifImageView.setImageUrl(gifList[indexPath.row].images.previewGIF.url)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "SearchTab", bundle: nil)
        let fifDetailViewController = storyBoard.instantiateViewController(withIdentifier: GifDetailViewController.identifier) as! GifDetailViewController
        fifDetailViewController.detailGif = self.gifList[indexPath.row]
        self.navigationController?.pushViewController(fifDetailViewController, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let searchKeyWord = searchKeyWord, let gifPagination = gifPagination else { return }
        if indexPath.row == gifList.count - 3, gifList.count < gifPagination.totalCount, gifList.count == gifPagination.offset + gifPagination.count {
            searchGif(keyWord: searchKeyWord, offset: gifPagination.offset + gifPagination.count)
        }
    }
}


extension SearchGiphyViewController: DynamicHeightFlowLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForCellAtIndexPath indexPath: IndexPath) -> CGFloat {
        let cellWidth: CGFloat = (view.bounds.width - 4) / 2
        let imageHeight = Double(gifList[indexPath.row].images.original.height)!
        let imageWidth = Double(gifList[indexPath.row].images.original.width)!
        let imageRatio = CGFloat(imageHeight / imageWidth)
        return imageRatio * cellWidth
    }
}

enum PlaceholderColor: Int {
    case Blue = 0
    case Purple = 1
    case Violet = 2
    case Pink = 3
}
