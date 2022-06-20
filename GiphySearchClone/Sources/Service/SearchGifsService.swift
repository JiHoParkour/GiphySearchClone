//
//  SearchGifsService.swift
//  GiphySearchClone
//
//  Created by yupzip on 2022/06/18.
//

import Alamofire

protocol SearchGifsServiceProtocol {
    func search(keyword: String, offset: Int, completionHandler: @escaping (APIResponse<Any>) -> Void)
}

class SearchGifsService: SearchGifsServiceProtocol {
    func search(keyword: String, offset: Int, completionHandler: @escaping (APIResponse<Any>) -> Void) {
        let url = "https://api.giphy.com/v1/gifs/search"
        let header: HTTPHeaders = ["Content-Type":"application/json"]
        let parameters: Parameters = ["api_key":Constants.giphyAPIKey,
                                      "q": keyword,
                                      "limit":"20",
                                      "offset":String(offset),
                                      "rating":"g"
        ]
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: header)
            .responseData { response in
                switch response.result {
                case .success:
                    guard let statusCode = response.response?.statusCode, let data = response.value else { return }
                    let result = self.judgeStatus(statusCode: statusCode, data)
                    completionHandler(result)
                case .failure: completionHandler(.networkFail)
                    break
                }
            }
    }
    
    private func judgeStatus(statusCode: Int, _ data: Data) -> APIResponse<Any> {
        switch statusCode {
        case 200: return decodeGifData(data: data)
        case 400: return .cliendError
        case 500: return .serverError
        default: return .networkFail
        }
    }
    
    
    private func decodeGifData(data: Data) -> APIResponse<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GifDataModel.self, from: data) else {
            return .cliendError
        }
        return .success(decodedData)
    }
    
}
