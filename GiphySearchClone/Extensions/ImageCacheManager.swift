//
//  ImageCacheManager.swift
//  GiphySearchClone
//
//  Created by yupzip on 2022/06/20.
//

import UIKit

class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    private init() {}
}
