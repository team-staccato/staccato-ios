//
//  NetworkService.swift
//  Staccato-iOS
//
//  Created by 강재혁 on 1/9/25.
//

import Foundation
import Alamofire

final class NetworkService {
    static let shared = NetworkService()
    private init() {}

    func request<T: Decodable>(
        endpoint: APIEndpoint,
        responseType: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        let urlString = endpoint.baseURL + endpoint.path
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }

        let method = HTTPMethod(rawValue: endpoint.method)
        let parameters = endpoint.parameters

        AF.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: responseType) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure:
                    completion(.failure(.requestFailed))
                }
            }
    }
}

