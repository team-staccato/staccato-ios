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
        // TODO:  base URL Config로 빼야될듯
        let urlString = "https://stage.staccato.kr" + endpoint.path
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }

        let method = HTTPMethod(rawValue: endpoint.method)
        let parameters = endpoint.parameters
        let headers = HTTPHeaders(endpoint.headers ?? [:])
        
        AF.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
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

protocol APIEndpoint {
    var path: String { get }
    var method: String { get }
    var parameters: [String: Any]? { get }
    var headers: [String: String]? { get }
}
