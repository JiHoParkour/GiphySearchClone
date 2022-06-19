//
//  GifsSearchResult.swift
//  GiphySearchClone
//
//  Created by yupzip on 2022/06/18.
//

import Foundation

enum GifsSearchResult {
    case success([Gif])
    case failure(Error)
}
