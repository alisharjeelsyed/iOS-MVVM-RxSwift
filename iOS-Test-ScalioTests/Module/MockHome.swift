//
//  MockHomeRouter.swift
//  iOS-Test-ScalioUITests
//
//  Created by Sharjeel Ali on 21/12/2021.
//

import Foundation
@testable import iOSTestScalio

final class MockHomeRouter: HomeRouterProtocol {

}

final class MockHomeServices: HomeServiceProtocol {
    
    private var searchWithFailure: Bool
    
    init(withFailure bool: Bool = false) {
        searchWithFailure = bool
    }
    
    func search(requestParam: SearchRequest, completion: @escaping (NetworkResult<SearchResultResponse>) -> ()) {
        
        guard !searchWithFailure
        else { return completion(.failure(NetworkError.unknown))}
        
        let testBundle = Bundle(for: type(of: self))
        if let path = testBundle.path(forResource: "MovieListData", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                            
                guard let decoder = try? JSONDecoder().decode(SearchResultResponse.self, from: data) else {
                    return completion(.failure(NetworkError.unknown))
                               
                }
                completion(.success(decoder))
                
            } catch {
                completion(.failure(error))
            }
        }
        else{
            completion(.failure(NetworkError.unknown))
        }
    }
}

enum NetworkError: Error {
    case invalidURL
    case responseError
    case unknown
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("Invalid URL", comment: "Invalid URL")
        case .responseError:
            return NSLocalizedString("Unexpected status code", comment: "Invalid response")
        case .unknown:
            return NSLocalizedString("Unknown error", comment: "Unknown error")
        }
    }
}
