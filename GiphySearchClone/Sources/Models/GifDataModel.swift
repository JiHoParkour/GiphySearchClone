//
//  GifDataModel.swift
//  GiphySearchClone
//
//  Created by yupzip on 2022/06/18.
//

import Foundation

struct GifDataModel: Codable {
    let data: [Gif]
    let pagination: Pagination
    let meta: Meta
    
    enum CodingKeys: String, CodingKey {
        case data
        case pagination
        case meta
    }
}
