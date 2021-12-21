//
//  JSONTranslator.swift
//  iOS-Test-Scalio
//
//  Created by Sharjeel Ali on 13/12/2021.
//

import Foundation
import Moya

public protocol JsonTranslatable {
    func convertDataResponseModel<T>(with response: Result<Response, MoyaError>) -> NetworkResult<T> where T: Decodable
    func converDataModelToParam<T:Encodable>(withModel model:T) -> [String:Any]?
}

/// Used to convert data Received from server in JSON format to `Generic Response type` provided in request.
/// Provided Response DataType must confirm Codable.
final class JsonTranslator: JsonTranslatable {
    
    public func convertDataResponseModel<T>(with response: Result<Response, MoyaError>) -> NetworkResult<T> where T: Decodable {
        switch response {
        case .success(let data):
            do {
                let response = try JSONDecoder().decode(T.self, from: data.data)
                return .success(response)
            }
            catch {
                return .failure(MoyaError.encodableMapping(error))
            }
            
        case .failure(let error):
            return .failure(error)
        }
    }

    func converDataModelToParam<T:Encodable>(withModel model:T) -> [String:Any]? {

           do {
               let encodedData = try JSONEncoder().encode(model)
               return try JSONSerialization.jsonObject(with: encodedData, options:.allowFragments) as? [String: Any]
           } catch {
               return nil
           }
       }
}
