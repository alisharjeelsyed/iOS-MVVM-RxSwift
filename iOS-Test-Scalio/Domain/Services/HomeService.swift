//
//  HomeService.swift
//  iOS-Test-Scalio
//
//  Created by Sharjeel Ali on 10/12/2021.
//

import Foundation
import Moya

//MARK: - Home Service  Protocol
protocol HomeServiceProtocol {
    func search(requestParam: SearchRequest, completion: @escaping (NetworkResult<SearchResultResponse>) -> ())
}

final class HomeService: HomeServiceProtocol {
    
    let jsonTranslator: JsonTranslatable = JsonTranslator()
    let networkManager: NetworkManager
    
    //MARK: - Init
    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func search(requestParam: SearchRequest, completion: @escaping (NetworkResult<SearchResultResponse>) -> ()) {
        
        let request = RequestMaker(
            baseUrl: APIConstants.baseURL,
            path: APIConstants.searchUsers,
            task: .requestParameters(
                parameters: jsonTranslator.converDataModelToParam(withModel: requestParam) ?? [:],
                encoding: URLEncoding.queryString)
        )

        networkManager.provider.request(request) { result in
            let mappedResponse: NetworkResult<SearchResultResponse> = self.jsonTranslator.convertDataResponseModel(with: result)
            completion(mappedResponse)
           
        }
    }
}

public enum NetworkResult<V> {
    case success(V)
    case failure(Error)
}
