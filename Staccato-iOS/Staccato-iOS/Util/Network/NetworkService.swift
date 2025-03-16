//
//  NetworkService.swift
//  Staccato-iOS
//
//  Created by 강재혁 on 2/8/25.
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
        let baseURL = Bundle.main.infoDictionary?["BASE_URL"] as! String
        let urlString = baseURL + endpoint.path
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let method = endpoint.method
        let parameters = endpoint.parameters
        let encoding = endpoint.encoding
        let headers = HTTPHeaders(endpoint.headers ?? [:])
        
        AF.request(
            url,
            method: method,
            parameters: parameters,
            encoding: encoding,
            headers: headers
        )
        .validate()
        .responseDecodable(of: responseType) { response in
#if DEBUG
            print("-------------------Response-------------------\n▫️\(method.rawValue) \(url) parameters: \(String(describing: parameters)) \n▫️statusCode: \(response.response?.statusCode ?? 0) \n▫️response: \(response) \n-----------------------------------------------")
#endif
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                print("❌ 알 수 없는 오류: \(error.localizedDescription)")
            }
        }
    }
}

protocol APIEndpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var encoding: ParameterEncoding { get }
    var parameters: [String: Any]? { get }
    var headers: [String: String]? { get }
}
