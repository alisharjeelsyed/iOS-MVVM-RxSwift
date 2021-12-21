//
//  AppNetworkManager.swift
//  iOS-Test-Scalio
//
//  Created by Sharjeel Ali on 10/12/2021.
//
import Moya
import Foundation

public struct RequestMaker: TargetType {
    public var baseURL: URL {
        guard let url = URL(string: _baseUrl) else { fatalError() }
        return url
    }
    public var path: String
    public var method: Moya.Method
    public var task: Task
    public var headers: [String : String]?
    
    private var _baseUrl: String
    
    //MARK: - Init
    public init(
        method: Moya.Method = .get,
        baseUrl: String,
        path: String = "",
        task: Task,
        headers: [String: String] = [:]) {
            
            self.method = method
            self._baseUrl = baseUrl
            self.path = path
            self.task = task
            self.headers = headers
        }
    
}

protocol Networkable {
    var provider: MoyaProvider<RequestMaker> { get }
    
}

class NetworkManager: Networkable {
    var provider = MoyaProvider<RequestMaker>(plugins: [NetworkLoggerPlugin()])
}

extension NetworkManager {
    func request<T: Decodable>(target: RequestMaker, completion: @escaping (Result<T, Error>) -> ()) {
        provider.request(target) { result in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(T.self, from: response.data)
                    completion(.success(results))
                } catch let error {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
