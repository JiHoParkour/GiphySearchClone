//
//  APIResponse.swift
//  GiphySearchClone
//
//  Created by yupzip on 2022/06/18.
//

import Foundation

enum APIResponse<T> {
    case success(T)
    case cliendError
    case serverError
    case networkFail
}
